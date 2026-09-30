# JavaScript Integration in QML

QML uses a standards-compliant JavaScript engine. JavaScript appears in property bindings, signal handlers, inline methods, and standalone JavaScript resources.

Source: https://doc.qt.io/qt-6/qtquick-usecase-integratingjs.html, https://doc.qt.io/qt-6/qtqml-javascript-topic.html

## Where JavaScript Is Used

- **Property bindings** — expressions that describe relationships between properties.
- **Signal handlers** — imperative code run when a signal is emitted.
- **Custom methods** — functions declared on QML objects.
- **Standalone JavaScript files** — imported as `import "file.js" as Logic`.

## JavaScript in Bindings

A binding is re-evaluated when its dependencies change. Functions with no dependency arguments (e.g., `Math.random()`) are **not** automatically re-evaluated.

```qml
Rectangle {
    height: width < 100 ? 100 : (width + 50) / 2
}
```

To establish or re-establish a binding from imperative code, use `Qt.binding()`:

```qml
Component.onCompleted: color = Qt.binding(function() { return inputHandler.pressed ? "steelblue" : "lightsteelblue" })
```

## Inline Custom Methods

Functions declared on a QML object become methods of that object and can be called from signal handlers, bindings, or externally.

```qml
Item {
    function fibonacci(n) {
        var arr = [0, 1];
        for (var i = 2; i <= n; i++) arr.push(arr[i - 2] + arr[i - 1]);
        return arr;
    }
    TapHandler { onTapped: console.log(fibonacci(10)) }
}
```

Methods on the root object are externally callable; if that is undesired, place the method on a non-root object or move it to a JavaScript file.

## JavaScript Resource Files

### Code-behind implementation files

Default import creates an isolated copy per QML component instance, preserving per-instance state.

```qml
// MyButton.qml
import QtQuick
import "my_button_impl.js" as Logic

Rectangle {
    id: rect
    MouseArea {
        anchors.fill: parent
        onClicked: Logic.onClicked(rect)
    }
}
```

```js
// my_button_impl.js
var clickCount = 0;  // separate for each MyButton instance
function onClicked(button) {
    clickCount += 1;
    button.color = (clickCount % 5 === 0) ? "red" : "green";
}
```

A code-behind file without its own `.import` statements runs in the importing QML component's scope and can access its objects and properties. If it has its own imports, pass needed values as parameters.

### Shared library files

Add `.pragma library` at the top of a `.js` file to load it once and share state across all importers.

```js
// factorial.js
.pragma library

var factorialCount = 0;

function factorial(a) {
    a = parseInt(a);
    if (a <= 0) {
        factorialCount += 1;
        return 1;
    }
    return a * factorial(a - 1);
}
```

Shared libraries cannot directly access QML component objects; values must be passed as parameters.

### Importing JavaScript resources

```qml
import "myscript.js" as Logic
import "factorial.js" as MathFunctions  // .pragma library shared resource
```

JavaScript resource qualifiers must start with an **uppercase letter** and be unique within the document.

From within another JavaScript resource, prefer standard ECMAScript modules for `.mjs` files:

```js
// factorial.mjs
export function factorial(a) { /* ... */ }
```

```js
// script.mjs
import { factorial } from "factorial.mjs";
export function showCalculations(value) { console.log(factorial(value)); }
```

The older `.import "filename.js" as Qualifier` syntax is deprecated.

## Dynamic Object Creation

Dynamically create objects to defer instantiation or respond to runtime events.

### From a Component

```qml
// main.qml
import QtQuick
import "componentCreation.js" as MyScript

Rectangle {
    id: appWindow
    Component.onCompleted: MyScript.createSpriteObjects()
}
```

```js
// componentCreation.js
var component;
var sprite;

function createSpriteObjects() {
    component = Qt.createComponent("Sprite.qml");
    if (component.status === Component.Ready)
        finishCreation();
    else
        component.statusChanged.connect(finishCreation);
}

function finishCreation() {
    if (component.status === Component.Ready) {
        sprite = component.createObject(appWindow, { x: 100, y: 100 });
        if (sprite === null) console.log("Error creating object");
    } else if (component.status === Component.Error) {
        console.log("Error loading component:", component.errorString());
    }
}
```

- `createObject(parent, { initialProperties })` returns the new object.
- For local files the status check can be skipped, but checking is safer for remote or async loads.
- Use `incubateObject()` for non-blocking instantiation.
- Relative URLs are resolved relative to the file where `Qt.createComponent()` is called.

### From a QML String

```qml
const newObject = Qt.createQmlObject(
    `import QtQuick
     Rectangle { color: "red"; width: 20; height: 20 }`,
    parentItem,
    "myDynamicSnippet"
);
```

**Avoid** this approach for static structures; it is slow, error-prone, and complicates static builds. Prefer pre-defined components.

### Creation Context and Lifetime

The creation context must outlive the dynamically created object; otherwise bindings and signal handlers stop working.

- `Qt.createComponent()` — context is the `QQmlContext` where called.
- `Qt.createQmlObject()` — context is the parent object's context.
- `Component.createObject()` / `incubateObject()` — context is where the `Component` object is defined.

Dynamically created objects do not have an `id`. Destroy them with `destroy(delayMs)`:

```qml
NumberAnimation on opacity {
    onFinished: root.destroy()
}
```

Do **not** manually delete objects created by convenience factories (`Loader`, `Repeater`) or objects you did not dynamically create.

## QML Global Object

The following host functions and objects are available without imports:

- `Qt` — QML helper object (e.g., `Qt.binding()`, `Qt.rgba()`, `Qt.createComponent()`).
- `qsTr()`, `qsTranslate()`, `qsTrId()` — translation helpers.
- `gc()` — manually trigger garbage collection.
- `print()` — print to console.
- `console` — subset of the FireBug Console API (`console.log`, `console.warn`, etc.).
- `XMLHttpRequest`, `DOMException` — subset of W3C spec.

## Environment Restrictions

- You cannot add or modify members of the JavaScript global object.
- All local variables must be explicitly declared; otherwise an exception is thrown.
- Use `this` carefully: it is only well-defined inside property binding functions assigned from JavaScript.

## Connecting Signals to JavaScript Functions

Connect a signal to an external JS function with `connect()`:

```qml
import QtQuick
import "script.js" as MyScript

Item {
    TapHandler { id: inputHandler }
    Component.onCompleted: inputHandler.tapped.connect(MyScript.jsFunction)
}
```

```js
// script.js
function jsFunction() { console.log("Called!"); }
```

## Common Pitfalls

- Calling `Math.random()` in a binding and expecting repeated re-evaluation.
- Using `Qt.createQmlObject()` for static UI instead of `.qml` files.
- Forgetting to declare `var`/`let`/`const`, which throws in QML.
- Destroying objects managed by `Loader` or `Repeater`.
- Storing references to dynamically created objects whose creation context may be destroyed first.

[Sources: https://doc.qt.io/qt-6/qtquick-usecase-integratingjs.html, https://doc.qt.io/qt-6/qtqml-javascript-expressions.html, https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html, https://doc.qt.io/qt-6/qtqml-javascript-resources.html, https://doc.qt.io/qt-6/qtqml-javascript-imports.html, https://doc.qt.io/qt-6/qtqml-javascript-qmlglobalobject.html]
