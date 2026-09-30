# Quickshell Core Types (`import Quickshell`)

The base module: windows, shell structure, shared singletons, and utilities.
Full type list: https://quickshell.org/docs/v0.3.0/types/Quickshell

## The `Quickshell` singleton

Global instance API. Key members:

- `screens : list<ShellScreen>` — reactive list of monitors; the canonical `Variants` model for
  per-monitor windows. `shellRoot`, `processId`, `clipboardText`, `workingDirectory`, `watchFiles`.
- Per-shell dirs (readonly, pragma-overridable): `dataDir`, `stateDir`, `cacheDir`, `configDir`,
  `shellDir` — plus `dataPath(p)`, `statePath(p)`, `cachePath(p)`, `configPath(p)`, `shellPath(p)`
  helpers. State dir default `~/.local/state/quickshell/by-shell/<shell-id>`.
- Functions: `env(name)`, `execDetached(cmd)` — fire-and-forget process launch,
  `iconPath(name[, theme])` / `hasThemeIcon(name)`, `hasVersion(major, minor[, features])`,
  `hasQtVersion(major, minor)`, `reload()`, `inhibitReloadPopup()`.
- Signals: `lastWindowClosed` (call `Qt.quit()` in its handler to exit on last close),
  `reloadCompleted`, `reloadFailed(errorString)`.

## Shell structure types

- `ShellRoot` — root scope object for a shell (top of `shell.qml`); default property holds children.
- `Scope` — non-visual grouping object. Use it (or ShellRoot) to hoist shared `Process`/`Timer`
  objects out of per-screen delegates.
- `Singleton` — root type for `pragma Singleton` files; one shared instance, importable by name.
- `Variants` — creates/destroys instances of a `delegate` Component for each entry in `model`
  (non-Item objects; like `Repeater` but for non-visual). Each instance gets `modelData` injected;
  `instances` lists live ones. **The** mechanism for multi-monitor bars:
  `Variants { model: Quickshell.screens; PanelWindow { required property var modelData; screen: modelData } }`
- `LazyLoader` — defers component creation into spare frame time (`loading: true` to preload,
  `active: true` to force-create now, `activeAsync`, `item`, `component`, `source`). Use for popups
  and rarely-shown windows to save memory and avoid blocking the UI thread.
- `Reloadable`/`Retainable`/`RetainableLock`, `PersistentProperties` (persist props across reloads),
  `ScriptModel`, `ObjectModel` (list model used by many service APIs), `BoundComponent`,
  `TransformWatcher`, `ElapsedTimer`.
- `SystemClock` — system time without a process: `SystemClock.date` + `Qt.formatDateTime()`;
  set `precision: SystemClock.Minutes` to save battery.
- `DesktopEntries`/`DesktopEntry`/`DesktopAction` — query installed .desktop apps and launch them.
- `ColorQuantizer`, `EasingCurve`, `Edges`, `Region`/`RegionShape`/`Intersection` (input/shape
  regions), `PopupAnchor`/`PopupAdjustment`, `QsMenuAnchor`/`QsMenuHandle`/`QsMenuOpener`/
  `QsMenuEntry`/`QsMenuButtonType` (context menus).

## Windows (`QsWindow` base)

- `PanelWindow` — decorationless window anchored to screen edges (bars, widgets, overlays).
  - `anchors { top|left|right|bottom: bool }` — all off by default. Two opposite anchors stretch
    the window across that axis; exclusive zones need 1 or 3 anchors set.
  - `exclusiveZone: int` — space reserved for the shell (sets `exclusionMode` to
    `ExclusionMode.Normal`). `exclusionMode`: `Auto` (default) / `Normal` / `Ignore`.
  - `aboveWindows: bool` (default true) — render over normal windows (maps to layer-shell layer).
  - `margins`, `focusable`, `screen` (ShellScreen — set per `modelData` from Variants).
- `FloatingWindow` — normal desktop window.
- `PopupWindow` — positioned relative to another window/item:
  `anchor.window: parentWin`, `anchor.rect.x/y`, `visible` (default false; won't show until anchor
  valid), `grabFocus`, `parentWindow`, `screen` (readonly). `relativeX/Y` deprecated → `anchor.rect`.

Typical root patterns:
```qml
ShellRoot { /* or Scope */ Variants { model: Quickshell.screens; PanelWindow { ... } } }
```

Sources:
https://quickshell.org/docs/v0.3.0/types/Quickshell/Quickshell
https://quickshell.org/docs/v0.3.0/types/Quickshell/PanelWindow
https://quickshell.org/docs/v0.3.0/types/Quickshell/PopupWindow
https://quickshell.org/docs/v0.3.0/types/Quickshell/Variants
https://quickshell.org/docs/v0.3.0/types/Quickshell/LazyLoader
https://quickshell.org/docs/v0.3.0/guide/introduction
