# Wayland & Compositor Integration

How Quickshell sits in a desktop session, and the compositor-specific modules.
Modules: https://quickshell.org/docs/v0.3.0/types/Quickshell.Wayland |
https://quickshell.org/docs/v0.3.0/types/Quickshell.Hyprland |
https://quickshell.org/docs/v0.3.0/types/Quickshell.I3

## Layer shell (`Quickshell.Wayland.WlrLayershell`)

`PanelWindow` is platform-agnostic; on wlroots compositors it's backed by `zwlr_layer_shell_v1`.
`WlrLayershell` is an **attached object** on PanelWindow:

```qml
PanelWindow {
  WlrLayershell.layer: WlrLayer.Top     // Background | Bottom | Top | Overlay
  WlrLayershell.namespace: "my-bar"     // like window class; can't change after connect
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
}
```

- `aboveWindows` on PanelWindow maps to the layer. `keyboardFocus` defaults to `None`.
- For cross-platform configs, set these conditionally:
  `Component.onCompleted: if (this.WlrLayershell != null) this.WlrLayershell.layer = WlrLayer.Bottom`

## Session lock (`WlSessionLock` / `WlSessionLockSurface`)

ext_session_lock_v1 lockscreen:

```qml
WlSessionLock {
  id: lock
  WlSessionLockSurface { /* content per screen; e.g. PamContext-driven prompt */ }
}
// lock.locked = true to engage
```

- `locked` engages the lock (only one lock at a time), `secure` (readonly) is true once the
  compositor confirms all screens covered, `surface` component instantiates per screen.
- **Warning**: if the lock dies without `locked = false`, compositors keep screens locked showing
  solid color — secure by design, but it renders the session inoperable. Handle carefully in
  dev: `QS_DISABLE_CRASH_HANDLER` interactions apply.
- Pair with `Quickshell.Services.Pam` (PamContext) for password verification.

## Other Wayland types

- `Toplevel`/`ToplevelManager` — enumerate/operate open toplevel windows (taskbar, dock).
- `ScreencopyView` — live view of a screen/toplevel (screenshot thumbnails, alt-tab previews).
- `IdleMonitor`/`IdleInhibitor` — observe idle, prevent sleep/screen-off.
- `ShortcutInhibitor` — let a surface swallow compositor shortcuts.
- `BackgroundEffect` — compositor background effects (e.g. blur regions) where supported.
- `WlSessionLockSurface`, `WlrKeyboardFocus`, `WlrLayer` (enums above).

## Hyprland (`import Quickshell.Hyprland`)

Live bindings over Hyprland's IPC socket:

- `Hyprland` — monitors, workspaces, toplevels as reactive object lists
  (`HyprlandMonitor`, `HyprlandWorkspace`, `HyprlandToplevel`, `HyprlandWindow`).
- `HyprlandEvent` — raw IPC events for anything not covered by typed properties.
- `GlobalShortcut` — bind Hyprland global shortcuts to trigger shell actions.
- `HyprlandFocusGrab` — grab keyboard/pointer input for a window (dropdowns, launchers).
- `HyprlandWindow` — Hyprland-specific `QsWindow` properties.

## i3 (`import Quickshell.I3`)

- `I3` — workspaces/monitors via i3 IPC (`I3Workspace`, `I3Monitor`); `I3Event` raw events;
  `I3IpcListener` custom subscriptions. Works for sway too (i3-compatible IPC).

## Coexistence notes

- Quickshell runs *alongside* the compositor — it consumes Wayland protocols, it doesn't conflict
  with other layer-shell clients (multiple bars/panels can share edges; struts stack by compositor).
- Singleton system services are different: notification server, tray host, polkit agent, session
  lock can each only have **one** owner per session — running both Quickshell's and a DE's
  equivalent means one wins (see services.md).
- Unsupported WM? Wayland layer-shell/toplevel modules still work on any wlroots or
  ext-protocol-supporting compositor; Hyprland/I3 modules are optional imports — guard usage so the
  shell degrades gracefully (check `!= null`/feature detection, or `//@ if env("XDG_CURRENT_DESKTOP")`).
- `XDG_CURRENT_DESKTOP`/`env()` + pragma if/endif or `Quickshell.env()` lets one config branch per
  compositor.
