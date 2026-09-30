---
description: Build and debug Quickshell (qs) desktop shells/widgets — QML-based toolbars, panels, lockscreens, and system widgets on Wayland/X11. Covers config layout, core window types, IO/process/file/IPC integration, system services (notifications, tray, pipewire, mpris, network, bluetooth, power), compositor modules (layer-shell, Hyprland, i3), pragmas/env, hot-reload debugging, and real-time vs deferred UI design.
---

# Quickshell

Quickshell (`qs`) is a toolkit for building desktop shells — bars, widgets, popups, lockscreens,
notification daemons, launchers — declared in **QML** and rendered by QtQuick. A "config" is a
folder containing `shell.qml`; Quickshell adds its own QML modules (`Quickshell`,
`Quickshell.Io`, `Quickshell.Services.*`, `Quickshell.Wayland`, `Quickshell.Hyprland`,
`Quickshell.I3`, `Quickshell.Widgets`, `Quickshell.WindowManager`) on top of stock Qt/QML.

**Reach for this skill when**: writing/editing a `shell.qml` or Quickshell config, adding a
system-integration widget (volume, battery, media, tray, workspaces), debugging a running `qs`
instance, or deciding how a desktop UI should update (bindings vs timers vs lazy loading).

**Scope note**: this skill covers *Quickshell's* API surface. QML/QtQuick language depth
(general syntax, stock `Item`/`Text`/`Timer`/layout types) is deliberately kept thin — see
`refs/qml-primer.md` for the minimum, and a dedicated QML skill or
https://doc.qt.io/qt-6/qtquick-qmlmodule.html for depth. Docs captured for Quickshell v0.3.0;
the API is pre-1.0 and changes between releases — check `hasVersion`/the version switcher when
behavior differs.

## Reference files (in `refs/`)

- `refs/qml-primer.md` — minimum QML needed to read/write Quickshell configs: file structure,
  bindings, ids/scoping, signals, singletons. Consult first if the QML itself is unfamiliar.
- `refs/setup-and-config.md` — install/dependencies, config discovery (`~/.config/quickshell`,
  `-c`/`-p`), `//@ pragma` options, env vars, editor/qmlls setup.
- `refs/debugging.md` — hot reload behavior, crash handler env vars, common errors
  (ReferenceError ids, zero-size items, binding loops, icon themes), `qs ipc` inspection.
- `refs/core-types.md` — `Quickshell` singleton (screens, dirs, env, reload, exec), `ShellRoot`,
  `Scope`, `Singleton`, `Variants`, `LazyLoader`, `PanelWindow`/`FloatingWindow`/`PopupWindow`,
  `SystemClock`, `DesktopEntries`.
- `refs/io-and-integration.md` — `Process`, stream parsers, `FileView`/`JsonAdapter`,
  `Socket`/`SocketServer`, `IpcHandler` + `qs ipc` — everything touching files, commands, or
  external programs.
- `refs/services.md` — notification server, MPRIS, Pipewire, system tray/DBusMenu, UPower,
  NetworkManager, Bluetooth, Pam, Polkit, Greetd; including one-owner-per-session caveats.
- `refs/wayland-and-compositors.md` — `WlrLayershell` attached props, `WlSessionLock`,
  toplevel/idle/screencopy types, Hyprland & i3 IPC modules, compositor coexistence.
- `refs/ui-design-practices.md` — real-time vs deferred update patterns, size/position rules,
  per-monitor structure, performance and persistence practices.

## Quick orientation

- Run: `qs` (default config), `qs -c name`, `qs -p path`. Edits live-reload on save.
- Every shell is `ShellRoot`/`Scope` → windows (`PanelWindow` anchored to edges, `FloatingWindow`,
  `PopupWindow`) → QtQuick items, with `Variants { model: Quickshell.screens }` for multi-monitor.
- Reactive = bindings to service singletons; deferred = `Timer`/`Process`/`FileView`/`LazyLoader`.
- System services (notifications, tray, polkit) are singletons — one owner per session; Quickshell
  replaces that desktop component rather than complementing it.

Source: https://quickshell.org/docs/v0.3.0/ — type reference root:
https://quickshell.org/docs/v0.3.0/types/ — examples:
https://git.outfoxxed.me/outfoxxed/quickshell-examples
