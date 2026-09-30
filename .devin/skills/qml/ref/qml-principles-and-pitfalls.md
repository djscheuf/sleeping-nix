# QML Principles, Conventions, and Pitfalls

These guidelines capture the design philosophy behind effective QML development: declarative UI design, clear separation of concerns, type safety, and performance awareness.

Sources: https://doc.qt.io/qt-6/qml-codingconventions.html, https://doc.qt.io/qt-6/qtquick-bestpractices.html, https://doc.qt.io/qt-6/qtquick-performance.html, https://doc.qt.io/qt-6/scalability.html

## Coding Conventions

Structure object declarations in this order, separated by empty lines:

1. `id`
2. Property declarations
3. Signal declarations
4. JavaScript functions
5. Object properties
6. Child objects

```qml
Rectangle {
    id: photo

    property bool thumbnail: false
    property alias image: photoImage.source

    signal clicked

    function doSomething(x) { return x + photoImage.width; }

    color: "gray"
    x: 20; y: 20
    height: 150
    width: {
        if (photoImage.width > 200) photoImage.width;
        else 200;
    }

    states: [ /* ... */ ]
    transitions: [ /* ... */ ]

    Rectangle {
        id: border
        anchors.centerIn: parent
        color: "white"

        Image { id: photoImage; anchors.centerIn: parent }
    }
}
```

### Grouped properties

Use group notation when multiple sub-properties of the same group are set together:

```qml
anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: 20 }
font { bold: true; italic: true; pixelSize: 20; capitalization: Font.AllUppercase }
```

### Unqualified access

Always reference parent component properties by their `id` explicitly. It improves readability and performance.

```qml
Item {
    id: root
    property int rectangleWidth: 50
    Rectangle { width: root.rectangleWidth }
}
```

### Required properties

Use `required` properties for data that comes from outside the component. Creation fails if they are not set, making dependencies explicit and enabling tooling to reason about types.

```qml
Rectangle {
    required property string title
}
```

### Signal handlers

Use named-parameter functions rather than plain code blocks:

```qml
MouseArea {
    onClicked: event => { console.log(`${event.x},${event.y}`); }
}
```

### Functions

Add type annotations when possible; extract long scripts into functions or external JavaScript files.

```qml
function calculateWidth(object: Item) : double {
    var w = object.width / 3;
    // ...
    return w;
}

Rectangle { color: "blue"; width: calculateWidth(parent) }
```

For scripts longer than a couple of lines, prefer a separate `.js` file:

```qml
import "myscript.js" as Script
Rectangle { color: "blue"; width: Script.calculateWidth(parent) }
```

## Architectural Principles

### Prefer built-in controls

Use Qt Quick Controls and their built-in styles before building custom controls. Create custom controls only when existing controls cannot satisfy the need.

### Separate UI from business logic

- Keep UI in QML (declarative, designer-friendly, rapid iteration).
- Keep heavy computation, data processing, and complex state in C++ or another strongly typed backend.
- Push C++ references into QML via `required` properties, `QQmlApplicationEngine::setInitialProperties`, or singletons, rather than letting C++ types depend on QML.

### Bundle resources

Use Qt's resource system or `qt_add_qml_module` with `RESOURCES` so assets are embedded in the binary and available regardless of OS filesystem restrictions.

```cmake
qt_add_qml_module(my_module
    URI MyModule
    VERSION 1.0
    QML_FILES main.qml
    RESOURCES images/image1.png images/image2.png
)
```

Keep QML files in the same directory as the `CMakeLists.txt` defining the module to avoid implicit-import mistakes.

## Layout and Positioning Guidelines

### Choosing a positioning mechanism

| Approach | Best for |
|----------|----------|
| `x`/`y`/`width`/`height` bindings | Fastest, simplest, delegates |
| Anchors | Static parent-child relationships |
| Positioners (`Row`, `Column`, `Grid`, `Flow`) | Regular arrangements that do not need resize |
| Layouts (`RowLayout`, `ColumnLayout`, `GridLayout`) | Resizable windows and constraint-based sizing |

### Layout do's and don'ts

**Do:**
- Size the layout itself with anchors or explicit `width`/`height` against its non-layout parent.
- Use `Layout` attached properties for immediate children of a layout.

**Don't:**
- Use anchors on an immediate child of a layout.
- Define `preferredWidth`/`preferredHeight` for items with satisfactory `implicitWidth`/`implicitHeight`.
- Use layouts or anchors inside list/table delegates or control styles when simple bindings are enough.

```qml
RowLayout {
    id: layout
    anchors.fill: parent
    spacing: 6
    Rectangle {
        color: "orange"
        Layout.fillWidth: true
        Layout.minimumWidth: 50
        Layout.preferredWidth: 100
        Layout.maximumWidth: 300
        Layout.minimumHeight: 150
    }
}
```

### Store state in models, not delegates

List and table delegates should be stateless; persistent selection or data state belongs in the model.

## Type Safety

Avoid `var` for property declarations when a concrete type exists:

```qml
// Bad
property var name
property var size
property var optionsMenu

// Good
property string name
property int size
property MyMenu optionsMenu
```

Using `var` makes errors harder to locate and prevents static analysis.

## Property Change Signals

Prefer explicit interaction signals over generic value-changed signals to avoid feedback loops.

```qml
Slider {
    value: someValueFromBackend
    onMoved: pushToBackend(value)     // explicit user interaction
    // Avoid: onValueChanged: pushToBackend(value)
}
```

`valueChanged` can fire due to clamping, rounding, or backend updates, leading to accidental cascades.

## Performance Principles

### Frame budget

Aim to keep per-frame processing within the available budget (commonly ~16 ms at 60 FPS). This means:

- Prefer asynchronous, event-driven programming.
- Offload heavy work to worker threads or C++ backends.
- Never manually spin the event loop (do not create `QEventLoop` or call `QCoreApplication::processEvents()` from a signal handler or binding).
- Avoid blocking functions that spend more than a few milliseconds per frame.

### Profile first

Use the QML Profiler (Qt Creator / VS Code extension) to find actual bottlenecks before optimizing. Optimizing without profiling usually produces only minor gains.

### JavaScript and value-type costs

Accessing a value-type property from JavaScript can allocate a wrapper and copy the underlying C++ value. Repeated lookups in tight loops are expensive.

```qml
// Bad: resolves rect.color four times per iteration
for (var i = 0; i < 1000; ++i) {
    printValue("red", rect.color.r);
    printValue("green", rect.color.g);
    printValue("blue", rect.color.b);
    printValue("alpha", rect.color.a);
}

// Better: resolve once per iteration
var rectColor = rect.color;
for (var i = 0; i < 1000; ++i) { /* ... */ }

// Best: resolve once outside the loop
var rectColor = rect.color;
```

### Sequence types

Sequences of value types are copied on every assignment or in-place modification. For large or frequently changed collections, prefer lists of object types (`QQmlListProperty`) over value-type sequences.

### Property bindings

Keep binding expressions simple. If only the final result matters, accumulate in a temporary variable and assign once, rather than updating the bound property incrementally inside a loop.

```qml
// Bad: triggers re-evaluation every iteration
for (var i = 0; i < someData.length; ++i) accumulatedValue += someData[i];

// Good: one assignment at the end
var temp = accumulatedValue;
for (var i = 0; i < someData.length; ++i) temp += someData[i];
accumulatedValue = temp;
```

### Type conversion

Most simple value-type conversions are cheap, but some are expensive (e.g., creating a `url` from a `string` constructs a `QUrl`). Be aware of this in hot paths.

## Scalability

Design for multiple screen sizes and densities:

- Use Qt Quick Controls and Qt Quick Layouts.
- Use property bindings for custom responsive behavior.
- Select a reference device and compute scaling ratios for images, fonts, and margins.
- Use file selectors or asset suffixes (`@2x`, `@3x`, `@4x`) to load platform- or density-specific assets where the platform supports it.
- Defer loading with `Loader`.

For orientation-aware layouts, use a `GridLayout` whose `flow` depends on width/height:

```qml
GridLayout {
    flow: width > height ? GridLayout.LeftToRight : GridLayout.TopToBottom
    // ...
}
```

## Common Pitfalls

| Pitfall | Why it hurts | Remedy |
|---------|--------------|----------|
| `var` everywhere | Loses type info, delays errors | Use concrete types |
| Static assignment breaking bindings | UI stops updating | Use `Qt.binding()` or redesign |
| Complex bindings with loops/side effects | Slow, hard to reason about | Move logic to functions/models |
| Anchors inside layouts | Conflicts with layout sizing | Use `Layout.*` attached properties |
| Storing state in delegates | Lost on reuse, inconsistent | Store state in the model |
| `onValueChanged` for user input | Feedback loops from normalization | Use interaction signals (`onMoved`, etc.) |
| Dynamic creation from strings | Slow, brittle, bad for static builds | Use `.qml` components |
| Manually spinning event loop | Re-entrancy, crashes | Use async/worker APIs |

[Sources: https://doc.qt.io/qt-6/qml-codingconventions.html, https://doc.qt.io/qt-6/qtquick-bestpractices.html, https://doc.qt.io/qt-6/qtquick-performance.html, https://doc.qt.io/qt-6/scalability.html]
