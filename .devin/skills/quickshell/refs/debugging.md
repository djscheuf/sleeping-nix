# Debugging Quickshell

## Hot reload and file watching

- Quickshell **live-reloads on save**: leave `qs` running, edit the `.qml`, the shell reloads.
  Disable with `QS_DISABLE_FILE_WATCHER` or `Quickshell.watchFiles = false`.
- On reload, `LazyLoader`s load synchronously so windows can be reused.
- A reload-popup notification appears by default; disable via `QS_NO_RELOAD_POPUP` or by calling
  `Quickshell.inhibitReloadPopup()` from the config.
- Signals on the `Quickshell` singleton: `reloadCompleted()`, `reloadFailed(errorString)` — hook
  these to log or gate behavior around reloads. `Quickshell.reload()` triggers a reload
  programmatically.

## Crashes and the crash handler

- Quickshell ships a crash handler that relaunches the shell. `QS_DISABLE_CRASH_HANDLER` disables
  it entirely (useful under a debugger); `QS_CRASHREPORT_URL` redirects the report link.
- Run `qs` from a terminal to see `WARN scene:` / `ReferenceError`/`TypeError` logs — e.g.
  `ReferenceError: clock is not defined` means an `id` was referenced outside its component scope.
- Warning: if a `WlSessionLock` is destroyed without `locked: false`, compositors leave screens
  locked to a solid color (by design). See wayland-and-compositors.md.

## Common runtime pitfalls (from FAQ + docs)

- **Invisible/zero-sized item**: most QtQuick items are zero size by default; a custom container
  with no `implicitWidth/Height` renders nothing. Set implicit size or use MarginWrapper/layouts.
- **Binding loop**: containers like `childrenRect` + children sized off it create loops; follow
  "implicit size flows up, actual size flows down" (see ui-design-practices).
- **`ReferenceError` on ids**: ids don't cross `Component`/`Variants` delegate boundaries — hoist
  shared state to properties on a common ancestor or a `Singleton`.
- **LSP not working**: qmlls fails on malformed files (unclosed braces), gives no docs for
  Quickshell types, and can't resolve `PanelWindow` — these are known limits, not your config.
  Ensure `.qmlls.ini` exists next to `shell.qml` (Quickshell populates it).
- **`root:/` imports**: break both qmlls and singletons — use relative/directory imports.
- **One process per widget?** No — a `Process` per widget wastes memory; share one Process/Timer and
  broadcast via properties.
- **"Hole" in a window / transparency issues**: see the FAQ entries on rounded windows, opacity, and
  `Region`/mask usage — rounding is done by clipping content, and transparency problems are usually
  an opaque background item or missing `color: "transparent"` on the window.
- **Purple/black icons**: missing/broken icon theme — set `//@ pragma IconTheme <theme>` or
  `QS_ICON_THEME`, ensure the theme is installed.
- **X11 strut/positioning weirdness**: try `QS_NO_XINERAMA_STRUTS`.
- **Reduce memory**: `//@ pragma DropExpensiveFonts`, lazy-load rarely-shown windows
  (`LazyLoader`/`Retainable`), avoid a process per widget.

## Inspecting a running shell

- `qs ipc list`, `qs ipc call <target> <fn> [args]`, `qs ipc wait` — query/call `IpcHandler`s
  exposed by the running instance (see io-and-integration.md). Useful for poking state without
  editing code.
- `Quickshell.processId`, `Quickshell.screens`, `Quickshell.shellRoot` give runtime introspection.

Sources:
https://quickshell.org/docs/v0.3.0/guide/faq
https://quickshell.org/docs/v0.3.0/guide/advanced
https://quickshell.org/docs/v0.3.0/types/Quickshell/Quickshell
