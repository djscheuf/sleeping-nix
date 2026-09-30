# QML Primer for Quickshell

Quickshell configs are written in QML (Qt Modeling Language). This file covers just enough QML to
read and write `shell.qml` files. For anything deeper — full syntax, QtQuick types (`Text`,
`Rectangle`, `MouseArea`, `Repeater`, `Timer`, `Component`, `Item`, layouts), JavaScript behavior —
consult a dedicated QML skill if one exists in this project, or the Qt docs:

- QML tutorial: https://doc.qt.io/qt-6/qml-tutorial.html
- QtQuick types: https://doc.qt.io/qt-6/qtquick-qmlmodule.html
- Quickshell's own QML guide: https://quickshell.org/docs/v0.3.0/guide/qml-language

## Document structure

A `.qml` file is imports, then one root object:

```qml
import Quickshell       // module import
import QtQuick
import "sub/dir"        // directory import (its Uppercase.qml files become types)

PanelWindow {           // root object; children nest inside
  anchors { top: true; left: true; right: true }
  implicitHeight: 30

  Text {                // child object, goes in the "default property"
    anchors.centerIn: parent
    text: "hello"
  }
}
```

- Any `Uppercase.qml` file in an imported directory becomes a usable type. Lowercase files are not
  components.
- Quickshell docs recommend always writing explicit types (`property string foo`) to catch errors
  early.

## Properties, ids, bindings

- `property string time` defines a property; `required property var modelData` must be set by the
  creator.
- `id: clock` names an object **within its component only** — an `id` inside a `Component`/delegate
  cannot be referenced from outside it (a classic Quickshell error:
  `ReferenceError: clock is not defined`). To share state outward, define a property on a common
  ancestor and bind to it.
- `text: root.time` is a **property binding**, not a one-time assignment: the expression re-evaluates
  automatically whenever `root.time` changes. This reactive binding is the core of every
  "real-time" Quickshell UI.
- Assigning imperatively (`onClicked: root.time = "x"`) **breaks** an existing binding. To remove a
  binding explicitly assign `undefined`-equivalent or use `Binding`/`PropertyChanges`.

## Signals and functions

```qml
Process {
  stdout: StdioCollector {
    onStreamFinished: root.time = this.text   // signal handler: on + SignalName
  }
}
function refresh() { dateProc.running = true }
```

- Signals declared with `signal foo(arg)`; handled with `onFoo`. Property changes emit implicit
  `<prop>Changed` signals (`onRunningChanged`).
- `Component.onCompleted` runs when the object finishes construction — the usual place for setup.

## Custom types, singletons, components

- `pragma Singleton` at the top of a file + `Singleton {}` (Quickshell type) as root makes one shared
  instance importable anywhere by file name (`Time.time`). Standard Quickshell pattern for state.
- `Component { ... }` defines an inline reusable tree; `delegate`/`model` consumers instantiate it.
- `Loader`/`LazyLoader` create components on demand (see core-types).

## What Quickshell adds on top

Quickshell is *not* a different language — it's QML modules (`Quickshell`, `Quickshell.Io`,
`Quickshell.Services.*`, `Quickshell.Wayland`, ...) plus `//@ pragma` comments that affect file
preprocessing and the instance (see setup-and-config.md). Anything valid in QML works inside a
Quickshell config; the Quickshell types add windows, system services, and IO.

Source: https://quickshell.org/docs/v0.3.0/guide/qml-language
