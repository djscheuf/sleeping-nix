# OBS Studio — Getting Started

Distilled from `obsproject.com/kb` (Getting Started, OBS Studio, FAQ categories). Linux-first; Windows/macOS notes included where behavior differs.

## Installation (Linux-first)

| Platform | Method |
|----------|--------|
| NixOS | Add `obs-studio` to `environment.systemPackages` (nixpkgs). Plugins via `pkgs.obs-studio-plugins.*` wrapped through `obs-studio.override { plugins = [...] }` or `wrapOBS` — see nixpkgs `obs-studio` docs. |
| Ubuntu (18.04+) | `sudo add-apt-repository ppa:obsproject/obs-studio && sudo apt install obs-studio` |
| Other distros | Flathub Flatpak is the officially recommended install (non-Ubuntu). Also see OBS GitHub wiki "Install instructions → Linux". |
| Build from source | OBS wiki "Build Instructions for Linux" |
| Windows | Installer or ZIP from obsproject.com/download |
| macOS | Installer from obsproject.com/download; requires permissions (see below) |

### System requirements

- **Windows**: DirectX 10.1+ GPU, Windows 10/11.
- **macOS**: Intel or Apple Silicon, OpenGL 3.3+ GPU, macOS 11+.
- **Linux**: OpenGL 3.3+ GPU, X11 or Wayland.
- CPU/GPU load depends heavily on encoder, resolution, FPS, and scene complexity — use Tools → **Auto-Configuration Wizard** to size settings to hardware.

### macOS permissions (note only)

macOS requires granting OBS screen-recording, camera, microphone, and accessibility permissions in System Settings; without them capture sources appear black. Full details: `kb/macos-permissions-guide`.

## Config file layout

OBS stores all user configuration in a per-user config directory:

| Platform | Path |
|----------|------|
| Linux | `~/.config/obs-studio/` |
| Windows | `%APPDATA%\obs-studio\` |
| macOS | `~/Library/Application Support/obs-studio/` |

Key subdirectories/files:

- `basic/profiles/<ProfileName>/` — Profile settings (`basic.ini` holds output/video/audio settings; `service.json` holds stream service config).
- `basic/scenes/<Name>.json` — one JSON file per Scene Collection: scenes, sources, filters, transitions, transforms. **This is the file to edit/patch when configuring scenes programmatically.**
- `global.ini` — global app settings (theme, hotkeys, general prefs).
- `plugin_config/` — per-plugin config (e.g. obs-websocket settings).
- `logs/` — dated log files; the first place to look when debugging capture/encoder failures.
- `plugin_data/` — data written by plugins/scripts.

Scene-collection JSON and profile `basic.ini` are the primary machine-editable artifacts; changes take effect on next launch (edit while OBS is closed, or reload the collection).

## Profiles vs Scene Collections

Two independent save/switch axes — do not confuse them:

- **Profile** (Profile menu): stores *output-related settings* — Stream service + connected account, Video (base/canvas + output resolution, FPS), and all Output settings (encoders, bitrates, recording). Does **not** store scenes. Use cases: Twitch vs YouTube profile, 1080p vs 4K, home vs mobile bitrate. Import/export is a JSON file.
- **Scene Collection** (Scene Collection menu): stores *all scenes, sources, filters, transitions* **plus** the Global Audio Sources from Settings → Audio. Does **not** store output settings. Import can migrate OBS Classic, XSplit, or Streamlabs Desktop collections and auto-adjusts collections made on other OSes.

Mix-and-match: profile "Twitch-1080p" + scene collection "Podcast" are orthogonal.

## Launch parameters

| Parameter | Effect |
|-----------|--------|
| `--startstreaming` / `--startrecording` / `--startvirtualcam` / `--startreplaybuffer` | Auto-start that output on launch |
| `--collection "name"` / `--profile "name"` / `--scene "name"` | Start with given collection / profile / scene |
| `--studio-mode` | Start in Studio Mode |
| `--minimize-to-tray` | Start minimized to tray |
| `--multi`, `-m` | Suppress "already running" warning for multiple instances |
| `--portable`, `-p` | Portable mode (**Windows only** — not supported on Linux/macOS) |
| `--safe-mode` | Disable all third-party plugins, scripts, websockets — first step when OBS misbehaves after installing add-ons |
| `--verbose` / `--unfiltered_log` | More/更 complete logging |
| `--disable-missing-files-check` | Skip missing-files dialog |
| `--only-bundled-plugins` | Run built-in modules only |
| `--allow-opengl` | OpenGL renderer (Windows; default on Linux) |
| `--help`, `--version` | Info |

## First-run workflow (Quick Start condensed)

1. **Auto-Configuration Wizard** — runs on first launch (Tools → Auto-Configuration Wizard). Sets encoder/bitrate/resolution based on hardware, usage goal (stream vs record), and network test.
2. **Add sources** — Sources dock → `+`. Starters: Display Capture / Window Capture (Linux & Windows), Video Capture Device (webcam), Game Capture (Windows only).
3. **Verify audio** — Audio Mixer meters should move; if not, Settings → Audio and pick devices manually.
4. **Check Settings → Output**, then **test** Start Recording/Streaming for a few minutes before going live.

## Studio Mode

Studio Mode shows **Program** (live, right) and **Preview** (edit, left). Edit scenes invisibly, then click **Transition** (or a Quick Transition hotkey) to swap. Toggling Studio Mode is itself invisible to viewers. Enable via `--studio-mode` or the Studio Mode button.

## Settings panels at a glance (Simple output mode)

- **General** — theme, tray icon, confirmations, source snapping, auto-record-on-stream.
- **Stream** — service + server + stream key (or Custom Streaming Server URL).
- **Output** — video/audio bitrate for streaming; recording path, quality preset (Same as stream / High Quality / Indistinguishable / Lossless), encoder; Replay Buffer toggle.
- **Audio** — sample rate; up to 2 desktop + 3 mic/aux devices; push-to-mute/talk per device.
- **Video** — Base (Canvas) Resolution (match monitor/game res; changing it requires re-aligning sources), Output (Scaled) Resolution + downscale filter, Common FPS (30 vs 60 — 60 fps is much heavier).
- **Hotkeys** — stream/record/replay control, source show/hide, scene switching, PTT/PTM, Game Capture "capture foreground window". Linux/Windows: joystick→keyboard via antimicro.
- **Advanced** — filename formatting variables (e.g. `%CCYY-%MM-%DD_%hh-%mm-%ss`), stream delay, auto-reconnect. Leave the rest alone unless you know why.

## Keyboard shortcuts (Windows/Linux; macOS substitutes ⌘/⌥/⇧)

| Action | Shortcut |
|--------|----------|
| Undo / Redo | Ctrl-Z / Ctrl-Shift-Z |
| Copy / Paste / Remove source | Ctrl-C / Ctrl-V / Del |
| Move source up/down/top/bottom | Ctrl-Up / Ctrl-Down / Ctrl-Home / Ctrl-End |
| Edit / Reset transform | Ctrl-E / Ctrl-R |
| Fit / Stretch / Center to screen | Ctrl-F / Ctrl-S / Ctrl-D |
| Nudge source (preview) | Arrow keys |
| Crop source (preview) | Alt + drag bounding box |
| Stretch source freely | Shift + drag |
| Disable snapping temporarily | Ctrl + drag |
| Pan/zoom fixed preview | Space + drag / Space + scroll |

## Portable mode

**Windows only.** ZIP install + empty `portable_mode`/`portable_mode.txt` in root dir, or `--portable` flag. Not supported on Linux or macOS — on Linux run separate instances with `--multi` if needed. Note: media/image file paths inside a scene collection are absolute and not portable; edit the collection JSON when relocating.

## Debugging entry points

- OBS won't behave → `obs --safe-mode`, check `logs/` dir (or Help → Log Files → View Current Log).
- Missing media on collection move → edit paths in `basic/scenes/<collection>.json`.
- Wrong capture device/audio → Settings → Audio device pickers; see `audio-configuration.md`.
