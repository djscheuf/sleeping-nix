# UI Design Practices for Quickshell Apps

How to design real-time vs deferred UIs, size/position correctly, and keep a shell fast.
Sources: https://quickshell.org/docs/v0.3.0/guide/size-position |
https://quickshell.org/docs/v0.3.0/guide/qml-language (Reactive bindings, Lazy loading) |
https://quickshell.org/docs/v0.3.0/guide/faq

## Real-time vs deferred updates — the core decision

| Want | Use | Notes |
|---|---|---|
| Live-reactive UI (clock, volume, workspace list) | **Property bindings** to reactive sources | `text: Time.time`, `model: Quickshell.screens`, `Mpris.players`. Zero polling; UI tracks state automatically. |
| Periodic refresh of non-reactive data (command output, file contents) | `Timer { interval, repeat: true, onTriggered: ... }` re-running a `Process`/`FileView.reload()` | Prefer the largest acceptable interval; don't poll faster than the UI can change meaningfully. |
| Event-driven updates | Signals/service objects | `StdioCollector.streamFinished`, `NotificationServer.notification`, FileView `watchChanges`, compositor event objects. Prefer over timers whenever a push source exists. |
| Heavy/rarely-shown UI | `LazyLoader` (`loading`, `active`, `activeAsync`) | Popups/settings panels: loads in spare frame time, can unload after close to reclaim memory. Showing before background load finishes blocks the UI thread briefly. |
| Deferred one-shot work | `Component.onCompleted`, `Timer { repeat: false }`, or `loading` on a LazyLoader | Keep `onCompleted` light — heavy synchronous work delays first frame. |

Rule of thumb: **bind, don't poll**. If a value can change, express it as a binding to a reactive
property (service singletons, `SystemClock`, `Quickshell.screens`) instead of imperative refresh.
Prefer `SystemClock` over a `date` process; prefer service modules over `dbus-send`/`nmcli` loops.

## Sizing & positioning (the most common source of broken UIs)

- Every `Item` has **actual** (`width`/`height`) and **implicit** (`implicitWidth/Height`) size.
  Rule: *implicit size flows child → parent; actual size flows parent → child.* A container-managed
  item must not set its own size.
- Many QtQuick items are **zero size by default** — an invisible custom container is the #1 bug.
- Windows: `PanelWindow` sizes via anchors + `implicitHeight`/`implicitWidth`; children use
  `anchors.centerIn: parent`, `anchors.fill`, margins.
- Prefer `RowLayout`/`ColumnLayout`/`GridLayout` over `Row`/`Column` (unless intentionally breaking
  pixel alignment). `MarginWrapperManager`/`WrapperRectangle`/`WrapperItem`/`ClippingRectangle` from
  `Quickshell.Widgets` reduce margin/clip boilerplate.
- Avoid `childrenRect` bound to children sized off the parent — binding loops.

## Structure & reuse

- Split at ~1 widget concern per file; `Uppercase.qml` files become types. Put shared
  state/logic in `pragma Singleton` files accessed as `Name.prop`.
- Keep one `Process`/`Timer` per data source in a `Scope`/`Singleton`, not per widget instance —
  broadcast via properties so per-screen delegates stay cheap.
- Per-monitor windows: `Variants { model: Quickshell.screens }` — reacts to hotplug automatically.
- `PersistentProperties` for settings surviving reloads; FileView/`JsonAdapter` in
  `Quickshell.stateDir`/`dataDir` for on-disk app state; `Quickshell.env()` for user overrides.

## Performance & polish

- `//@ pragma DropExpensiveFonts`; `SystemClock.precision = SystemClock.Minutes` for battery.
- `LazyLoader` for anything not visible at startup; `Retainable` keeps created objects alive across
  reloads where appropriate.
- `MultiEffect` (QtQuick.Effects) over qt5compat blur. `IconImage`/`Quickshell.iconPath()` for themed
  icons; set `IconTheme` pragma.
- Conditional visibility: `visible: false` still costs layout; use `LazyLoader`/`Loader` for
  on-demand UI instead of hiding heavy trees.
- Test with `qs -p ./shell.qml` while iterating — reload is instant.
