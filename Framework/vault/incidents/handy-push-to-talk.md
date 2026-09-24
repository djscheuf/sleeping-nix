# Handy Push-to-Talk shortcut conflict

**Status: UNRESOLVED — Handy removed, config changes reverted.**

Date opened: 2026-09-24
Date closed (unresolved): 2026-09-24

## Summary

Handy's global keyboard shortcut (Push-to-Talk) never triggered a recording,
regardless of which key combination was assigned, which keyboard backend was
used, or whether permissions were correctly granted. Two independent root
causes were identified and fixed in isolation, but the underlying symptom
(no shortcut ever fires) persisted through both fixes. Given the effort
already invested without any observable improvement, Handy has been
uninstalled and all related system config changes reverted.

## Environment

- NixOS 25.11, host `Nox`, GNOME desktop, **native Wayland session**
  (`XDG_SESSION_TYPE=wayland`, `WAYLAND_DISPLAY=wayland-0`).
- Handy `0.9.6` from the pinned `nixpkgs-unstable` overlay (`pkgs.unstable.handy`).
- PipeWire audio, AMD Radeon 780M GPU (Vulkan backend used for transcription).

## Timeline of findings

### 1. IBus was grabbing `Ctrl+Space` (fixed, but insufficient)

The Handy log showed:

```text
register_tauri_shortcut duplicate error: Shortcut 'ctrl+space' is already in use
resume_all_shortcuts: could not register 'transcribe': Shortcut 'ctrl+space' is already in use
```

IBus registers `Control+space` as its global input-method trigger
(`org.freedesktop.ibus.general.hotkey trigger`), which conflicted with
Handy's default binding and prevented Tauri's global-shortcut plugin from
registering it. `Ctrl+Alt+Space`, `Ctrl+Tab`, and `` Ctrl+` `` were also
tried and each failed for similar reasons (already in use by the system, or
produced malformed bindings through the Handy settings UI, which appears to
have a bug that can corrupt a binding when toggling Push-to-Talk vs Toggle
mode — killing and restarting Handy was required to get a clean state
after that).

**Fix applied at the time:** cleared the IBus trigger
(`gsettings set org.freedesktop.ibus.general.hotkey trigger "[]"`) and reset
Handy's `transcribe` binding back to `ctrl+space`. Handy logged
`Shortcuts initialized successfully` with no further errors.

**This has been reverted** — the IBus trigger is restored to its original
value (`['Control+space']`).

### 2. Even with a clean registration, the shortcut never actually fired

After the IBus fix, `Ctrl+Space` registered without error, but **holding it
never started a recording** — no audio cue, no overlay, no log entry
indicating a key was recognized, in any application (terminal, GNOME Notes,
browser). This was true across multiple Handy restarts and multiple
alternate bindings.

Root cause hypothesis: this is a **native GNOME Wayland session**. Handy's
default keyboard backend (`keyboard_implementation: "tauri"`, backed by the
`global-hotkey` crate) grabs keys via X11 `XGrabKey` through XWayland. On
Mutter/GNOME Wayland this grab can register without error yet never
actually receive key events for a background/tray application — which
matches the observed symptom exactly (successful registration, zero
delivered events).

Diagnostic notes:
- Synthetic input testing via `xdotool keydown`/`keyup` is **not a valid
  test** in this environment: it triggers the
  `xdg-desktop-portal-gnome` **RemoteDesktop consent dialog** ("Allow Remote
  Interaction") instead of actually delivering the key event, because Mutter
  intercepts XTEST-injected input on Wayland sessions pending portal
  approval. This is almost certainly what happened in the *original*
  debugging session referenced in this ticket ("agent used a command-line
  tool to send keys, which appeared to launch the Remote Desktop
  interface") — it was a false signal, not evidence Handy was working.
  **Do not use xdotool/XTEST-based synthetic key injection to test Handy on
  this system.**

### 3. Switched to Handy's evdev backend (`HandyKeys`) — still no effect

Handy exposes an alternate keyboard backend, `KeyboardImplementation::HandyKeys`
(source: `src-tauri/src/settings.rs` in the Handy repo), which reads raw
`evdev` device events instead of relying on the compositor/X11 grab. This
requires:

1. `experimental_enabled: true` in Handy's settings (gates the UI toggle;
   also appears to be required for the setting to actually take effect).
2. `keyboard_implementation: "handy_keys"` in Handy's settings.
3. Read access to `/dev/input/event*`, which on this system is
   `root:input` with group rw. The `djs` user was **not** in the `input`
   group.

**Changes applied:**
- Added `"input"` to `users.users.djs.extraGroups` in
  `Framework/configuration.nix`.
- Ran `sudo nixos-rebuild switch` (succeeded).
- Fully logged out/in so the new group membership took effect —
  confirmed via `id djs` showing `174(input)` in the group list.
- Set `experimental_enabled: true` and `keyboard_implementation: "handy_keys"`
  in `~/.local/share/com.pais.handy/settings_store.json`.

**Important gotcha hit along the way:** editing `settings_store.json` while
an old Handy process is still running does not stick — Tauri's store plugin
flushes its in-memory (stale) state back to disk, silently reverting manual
edits. Always fully kill all `handy` processes (`pkill -9 -f handy`, then
confirm with `pgrep -af handy`) *before* editing the settings file.

**Result:** with the fix applied and confirmed via `id djs` and the debug
log, Handy came up cleanly:

```text
[handy_app_lib::shortcut::handy_keys][INFO] handy-keys manager thread started
[handy_app_lib::shortcut::handy_keys][DEBUG] Registered handy-keys shortcut: transcribe -> Hotkey { modifiers: Modifiers(CTRL_LEFT | CTRL_RIGHT), key: Some(Space) }
[handy_app_lib::shortcut::handy_keys][INFO] handy-keys shortcuts initialized
[handy_app_lib::commands][INFO] Shortcuts initialized successfully
```

No permission errors. No duplicate-binding errors. And yet: **still zero
log activity of any kind after startup**, across a 16+ minute window that
included a live test by the user (no recording-start event, no overlay, no
audio cue, nothing pasted). This rules out both suspected causes
(compositor grab failure, and file permissions) without fixing the actual
problem — the real keyboard input is not reaching Handy's evdev listener
either.

Devices present with `ID_INPUT_KEYBOARD=1`: `/dev/input/event0`, `event2`,
`event6`, `event22` (several correspond to the same physical USB keyboard's
different HID endpoints, e.g. normal keys vs. consumer-control keys). It's
possible Handy's evdev implementation is watching the wrong device node,
or only a subset of the enumerated keyboard devices, but this could not be
confirmed without upstream source access to the `handy_keys` module
internals or a way to add more verbose per-event tracing.

## Why this is being closed as unresolved

Two plausible, independent root causes (X11/Wayland shortcut grab
incompatibility; missing evdev permissions) were each identified and fixed
in turn, and neither produced any observable change in behavior — not even
partial improvement, not even a differently-shaped failure. That, combined
with the amount of time already invested across two debugging sessions,
suggests either a deeper bug in Handy's Linux/Wayland input handling on
this specific hardware/session combination, or an environment factor not
yet identified (e.g. a security/sandboxing layer blocking `evdev` reads
despite correct file permissions, multiple competing keyboard event nodes,
or something specific to this AMD/Mutter/GNOME combination).

## Reverted changes (as of this closure)

- `Framework/configuration.nix`: removed `"input"` from
  `users.users.djs.extraGroups`.
- `Framework/improving.nix`: removed `unstable.handy` from
  `users.users.djs.packages`.
- `gsettings`: restored `org.freedesktop.ibus.general.hotkey trigger` to
  `['Control+space']`.
- Handy processes killed; `~/.local/share/com.pais.handy/settings_store.json`
  removed (Handy's own store, regenerates with defaults if reinstalled).
- **User must run `sudo nixos-rebuild switch` to apply the configuration.nix
  / improving.nix reverts**, and log out/in afterward to drop the `input`
  group membership.

## Next actions (not yet done)

1. Run `sudo nixos-rebuild switch` to actually apply the reverted
   `configuration.nix`/`improving.nix` (removes Handy from the system and
   drops the `input` group grant).
2. Optionally clean up leftover Handy user data:
   `rm -rf ~/.local/share/com.pais.handy`
3. If push-to-talk dictation is still wanted, consider alternatives that are
   known to work well under GNOME Wayland (e.g. tools that use the
   `xdg-desktop-portal` `GlobalShortcuts` interface natively, or a
   compositor-level custom keybinding that shells out to a CLI transcription
   tool) rather than Handy's current X11/evdev-only approaches.
4. If revisiting Handy specifically, consider filing an upstream issue at
   <https://github.com/cjpais/Handy> describing: GNOME native Wayland
   session, both `Tauri` and `HandyKeys` backends silently receive zero
   events despite clean initialization and correct `/dev/input` permissions.

## References

- Handy docs: <https://handy.computer/docs>
- Handy NixOS package: <https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ha/handy/package.nix>
- Handy settings source (`KeyboardImplementation` enum):
  <https://raw.githubusercontent.com/cjpais/Handy/v0.9.6/src-tauri/src/settings.rs>
- Handy GitHub: <https://github.com/cjpais/Handy>
