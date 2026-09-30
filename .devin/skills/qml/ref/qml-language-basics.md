# QML Language Basics

QML is a multi-paradigm language: object trees and property relationships are declared, while imperative behavior is written with JavaScript expressions and signal handlers. QML code is loaded by the engine as **QML documents**.

Source: https://doc.qt.io/qt-6/qmlapplications.html, https://doc.qt.io/qt-6/qtqml-language-topic.html

## QML Document Structure

A QML document is a self-contained `.qml` file or text string with three parts in order:

1. **Pragmas** (optional) — engine directives such as `pragma Singleton`.
2. **Import statements** — one or more `import` lines.
3. **A single root object declaration**.

```qml
pragma Singleton
import QtQuick

Window {
    visible: true
    width: 400; height: 300
}
```

- Documents are always encoded in **UTF-8**.
- A `.qml` file whose name begins with an **uppercase letter** defines a reusable QML object type.

## Import Statements

Three import forms are available:

```qml
import <ModuleIdentifier> [<Version.Number>] [as <Qualifier>]
import "<DirectoryPath>" [as <Qualifier>]
import "<JavaScriptFile>" as <Identifier>
```

Examples:

```qml
import QtQuick                   // latest version, global namespace
import QtQuick 2.10              // explicit major.minor
import QtQuick as Quick           // qualified namespace
import "../privateComponents"     // directory import
import "somefile.js" as Script    // JavaScript resource import
```

- `Qualifier` lets multiple modules expose the same type name without conflict; usage becomes `Quick.Rectangle`.
- JavaScript resource imports **must** be qualified (`as Script`).
- Remote directory imports require a `qmldir` file so the engine can discover contents.

The QML engine searches the import path in this order (simplified):

- Platform bundle paths
- Directory of the application binary
- `qrc:/qt-project.org/imports`
- `qrc:/qt/qml` (since Qt 6.5)
- `QML_IMPORT_PATH` environment variable paths
- Paths added via `QQmlEngine::addImportPath()`
- Built-in Qt plugin paths

## Object Declarations and Object Tree

An object declaration creates one object (and optionally a tree of child objects):

```qml
Rectangle {
    width: 100; height: 100; color: "red"
}
```

Nested declarations produce child objects. For types based on `Item` (most visual types), unassigned children are appended to the type's **default property** (`children`), making them visual children as well.

- `parent` in visual types refers to the **visual parent**.
- The object-tree parent is fixed at creation; the visual parent can be changed from QML by setting `parent`.

## The `id` Attribute

```qml
TextInput { id: myTextInput; text: "Hello" }
Text { text: myTextInput.text }
```

Rules:

- At most one `id` per object.
- Must begin with a **lower-case letter** or underscore.
- Can contain only letters, numbers, and underscores.
- Must be unique within its QML context.
- Cannot be a JavaScript reserved word.
- **Not** a regular property; `myTextInput.id` is invalid, and its value cannot be reassigned.

## Property Attributes

Custom properties are declared with optional modifiers:

```qml
[default] [virtual] [override] [final] [required] [readonly] property <type> <name>
```

Examples:

```qml
property int clickCount
property color nextColor: "blue"
default property list<Item> d: [ Item { objectName: "inner" } ]
```

- Property names begin with a lower-case letter.
- Declaring a property implicitly creates a change signal and handler named `on<PropertyName>Changed`.
- Any value type or QML object type can be used as the property type.
- `var` is a generic holder but sacrifices type safety and error locality.

## Assigning Values

### Initialization assignment

```qml
width: 100
property color nextColor: "blue"
```

### Imperative assignment

```qml
Component.onCompleted: rect.color = "red"
```

**Important:** Imperative assignment with `=` replaces a property **binding** with a static value.

## Property Bindings

A binding is an expression assigned to a property. The engine re-evaluates the expression whenever its dependencies change.

```qml
Rectangle {
    width: 100
    height: width * 2   // binding: height tracks width
}
```

### Preserving/restoring bindings from JavaScript

A plain assignment destroys the binding. To keep or re-establish it, use `Qt.binding()`:

```qml
Keys.onSpacePressed: height = Qt.binding(function() { return width * 3 })
```

### `this` in bindings

Inside a binding expression assigned from JavaScript, `this` refers to the object receiving the binding:

```qml
Component.onCompleted: rect.height = Qt.binding(function() { return this.width * 2 })
```

Outside of bindings, `this` is undefined.

### Static vs binding values

| Kind | Semantics |
|------|-----------|
| Static value | Constant until explicitly reassigned. |
| Binding expression | JavaScript expression describing a relationship to other properties; updated automatically when dependencies change. |

Keep bindings simple. Multi-line loops or heavy computation inside bindings hurt performance and readability; prefer functions or model updates.

## Signal and Handler Event System

Signals are events; signal handlers respond to them. A handler is named `on<Signal>` with the signal name capitalized.

```qml
Button {
    onClicked: rect.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
}
```

### Property change handlers

Every writable property has an implicit change signal and handler:

```qml
Rectangle {
    property color nextColor
    onNextColorChanged: console.log(nextColor)
}
```

### Signal parameters

When a signal has parameters, assign a function to the handler:

```qml
Status {
    // signal errorOccurred(message: string, line: int, column: int)
    onErrorOccurred: (msg, line, col) => console.log(`${line}:${col}: ${msg}`)
}
```

- Parameter names in the handler do not need to match the signal declaration.
- Trailing parameters can be omitted; use `_` placeholders for unused leading parameters.
- Using a plain code block (not a function) is deprecated; parameters get injected into scope and lookups are slower.

### Connections

Use `Connections` to handle signals of an object declared elsewhere:

```qml
Connections {
    target: button
    function onClicked() { rect.color = "blue" }
}
```

### Attached signal handlers

Handlers such as `Component.onCompleted` belong to an **attaching type** (`Component`), not the object itself. They execute when the object finishes creation.

```qml
Rectangle {
    Component.onCompleted: console.log("created")
}
```

## Comments

Same as JavaScript:

```qml
// single-line comment
/* multi-line
   comment */
```

## Common Pitfalls

- Forgetting to import a module before using its types.
- Assigning a static value where a binding was intended; use `Qt.binding()` to preserve dynamic behavior.
- Treating `id` as a property.
- Using plain code blocks for signal handlers with parameters (deprecated and slower).

[Sources: https://doc.qt.io/qt-6/qtqml-syntax-basics.html, https://doc.qt.io/qt-6/qtqml-documents-structure.html, https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html, https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html, https://doc.qt.io/qt-6/qtqml-syntax-signals.html, https://doc.qt.io/qt-6/qtqml-syntax-imports.html]
