# QML Type System

QML distinguishes between **object types** (instantiable, reference-semantics) and **value types** (passed by copy, like primitives and structs). The engine enforces type safety for properties and instances.

Source: https://doc.qt.io/qt-6/qtqml-typesystem-topic.html

## Object Types

A **QML object type** can be instantiated in a QML document. Object types are passed by reference.

- Provided by QML modules (e.g., `Rectangle` from `QtQuick`).
- Every `.qml` file whose name begins with an **uppercase letter** implicitly defines a QML object type.
- Built-in object types that do not require an import: `QtObject`, `Component`.

### Defining types from QML files

File `SquareButton.qml`:

```qml
// SquareButton.qml
import QtQuick

Rectangle {
    property int side: 100
    width: side; height: side
    color: "red"
}
```

- The file name must match the desired type name and begin with an uppercase letter.
- The type is automatically available to other `.qml` files in the **same directory**.
- The **root object** of the file defines the externally accessible attributes (properties, signals, methods) of the type.
- Internal `id` values are **not** accessible from outside the component.

### Inline components

Declare a reusable component inside a file without creating a separate `.qml` file:

```qml
// Images.qml
import QtQuick

Item {
    component LabeledImage: Column {
        property alias source: image.source
        property alias caption: text.text

        Image { id: image; width: 50; height: 50 }
        Text { id: text; font.bold: true }
    }

    Row {
        LabeledImage { source: "before.png"; caption: "Before" }
        LabeledImage { source: "after.png"; caption: "After" }
    }
}
```

- Inline components are referenced by name inside the same file.
- From another file, prefix with the containing type: `Images.LabeledImage {}`.
- Inline components **do not share scope** with the component they are declared in; do not reference outer `id`s from inside them.
- Inline components **cannot be nested**.

### Component objects

`Component` defines an anonymous type inline, usually for dynamic creation:

```qml
Item {
    Component {
        id: myComponent
        Rectangle { width: 100; height: 100; color: "red" }
    }
    Component.onCompleted: myComponent.createObject(parent)
}
```

## Value Types

Value types are conceptually passed by value. Assigning a value type to two different properties produces two independent copies.

### Built-in value types (no import required)

| Type | Meaning |
|------|---------|
| `bool` | true/false |
| `date` | Date value |
| `double` | Double-precision number |
| `int` | Whole number |
| `list` | List of QML objects (must specify element type) |
| `real` | Number with decimal point |
| `string` | Text string |
| `url` | Resource locator |
| `var` | Generic holder for any value |
| `variant` | Generic holder (legacy alias) |
| `void` | Empty/absence of value |

### Common module-provided value types

`QtQml` module: `easingCurve`, `point`, `qmlProperty`, `rect`, `size`.

`QtQuick` module: `color`, `font`, `matrix4x4`, `quaternion`, `vector2d`, `vector3d`, `vector4d`.

### `var` vs concrete types

Prefer concrete types (`string`, `int`, `color`, etc.) over `var`. `var` hides the actual type, delays error detection, and prevents static analysis.

## Enumerations

Enumerations are properties of their surrounding type, not separate types. Access them as `Type.Value`.

```qml
Text { horizontalAlignment: Text.AlignRight }
```

- In C++, enums must be marked with `Q_ENUM`/`Q_ENUM_NS` and exposed via `QML_ELEMENT`/`QML_NAMED_ELEMENT`.
- Enumerations can be declared in QML itself; see [Enumeration Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html#enumeration-attributes).
- Helper functions on the `Qt` global object:
  - `Qt.enumStringToValue(enumType, "KeyName")`
  - `Qt.enumValueToString(enumType, value)`
  - `Qt.enumValueToStrings(enumType, value)`

## Sequence Types

A sequence stores multiple instances of an object or value type:

```qml
property list<int> ints: [1, 2, 3, 4]
property list<Connection> connections: [
    Connection { },
    Connection { }
]
```

- Value-type sequences are backed by `QList`.
- Object-type sequences are backed by `QQmlListProperty`.
- Sequences mostly behave like JavaScript `Array`, but:
  - Deleting an element sets it to a default-constructed value, not `undefined`.
  - Increasing `length` pads with default-constructed values.
  - Use `splice(startIndex, deleteCount)` to actually remove elements.
- Heavy conversion happens for C++ containers exposed as sequences; for performance-critical code, prefer `QQmlListProperty` or object lists.

## Singleton Types

A singleton is an object created at most once per QML engine. It is useful for application-wide state or constants.

### Declaring a QML singleton

```qml
// Theme.qml
pragma Singleton
import QtQuick

QtObject {
    property color background: "#202020"
    property int padding: 8
}
```

- Add `pragma Singleton` at the top.
- Register it in the module:
  - With CMake, set `QT_QML_SINGLETON_TYPE TRUE` on the file via `set_source_files_properties` before `qt_add_qml_module`.
  - With a manual `qmldir` file: `singleton Theme 1.0 Theme.qml`.

### Using singletons

```qml
import MyModule

Rectangle {
    color: Theme.background
}
```

- Bindings **to** singleton properties are not allowed directly; use a `Binding` element if necessary.
- Avoid too many singletons; they are global state that lives until the engine is destroyed. Group related data into a single singleton instead.

## Attached Types

Attached properties and signals are provided by one type and accessed on another, using the provider type as a namespace prefix.

```qml
ListView {
    model: 3
    delegate: Rectangle {
        color: ListView.isCurrentItem ? "red" : "yellow"
    }
}

Rectangle {
    Component.onCompleted: console.log("created")
}
```

Common attached types:

- `Component.onCompleted` / `Component.onDestruction`
- `ListView.isCurrentItem`, `ListView.view`
- `GridView` attached properties
- `Keys` attached properties for keyboard input

Use attached properties when information logically belongs to a container/context rather than the item itself.

## Namespaces

A **QML namespace** is a non-instantiable type that exposes enumerations. It can only be declared in C++ using `Q_NAMESPACE`, `QML_ELEMENT`, and `QML_NAMED_ELEMENT`.

## Type Safety Guidelines

- Prefer concrete property types over `var`.
- Use `required` properties for data that must be supplied from outside a component.
- Keep custom type file names uppercase and match the type name exactly (case-sensitive on UNIX).
- Do not rely on internal `id`s of a reusable type from outside its file.

[Sources: https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html, https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html, https://doc.qt.io/qt-6/qtqml-typesystem-enumerations.html, https://doc.qt.io/qt-6/qtqml-typesystem-sequencetypes.html, https://doc.qt.io/qt-6/qml-singleton.html, https://doc.qt.io/qt-6/qtqml-typesystem-attachedtypes.html, https://doc.qt.io/qt-6/qtqml-typesystem-namespaces.html, https://doc.qt.io/qt-6/qtqml-documents-definetypes.html]
