# Qt Quick Types and Patterns

Qt Quick is the standard library of QML types for building user interfaces. Import `QtQuick` to use the visual canvas, input handling, positioning, animations, and common value types.

Source: https://doc.qt.io/qt-6/qtquick-index.html

## Core Visual Types

Most visual types inherit from `Item`, which provides a common coordinate system, opacity, transform, and focus properties.

| Type | Purpose |
|------|---------|
| `Rectangle` | Colored rectangle, optionally with gradient, border, and rounded `radius` |
| `Image` | Display local or remote images via `source` |
| `BorderImage` | Scaleable nine-patch style border image |
| `AnimatedImage` | Animated GIF/MNG |
| `AnimatedSprite`, `SpriteSequence` | Sprite-based animations |
| `Canvas` | Custom 2D drawing with JavaScript API |
| `Text` | Display formatted text |
| `Window` | Top-level window |

Example:

```qml
Rectangle {
    width: 100; height: 100
    radius: 8
    color: "aqua"
    gradient: Gradient {
        GradientStop { position: 0.0; color: "aqua" }
        GradientStop { position: 1.0; color: "teal" }
    }
    border { width: 3; color: "white" }
}
```

## Positioning and Layouts

### Manual positioning

Set `x` and `y` directly; combine with bindings for relative positioning.

### Anchors

`Item` provides anchor lines (`left`, `right`, `top`, `bottom`, `horizontalCenter`, `verticalCenter`, `baseline`).

```qml
Rectangle {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.margins: 20
}
```

Group syntax is also valid:

```qml
anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 20 }
```

### Positioners

Positioner types arrange children automatically:

| Type | Arrangement |
|------|-------------|
| `Row` | Horizontal line |
| `Column` | Vertical line |
| `Grid` | Grid pattern |
| `Flow` | Flow like words in a paragraph |

```qml
Row {
    spacing: 20
    Rectangle { width: 80; height: 80; color: "red" }
    Rectangle { width: 80; height: 80; color: "green" }
    Rectangle { width: 80; height: 80; color: "blue" }
}
```

### Layouts

Qt Quick Layouts (`import QtQuick.Layouts`) resize children on window resize and support size constraints. Use `Layout` attached properties on immediate children:

```qml
import QtQuick.Layouts

RowLayout {
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

Key `Layout` attached properties:

- `Layout.fillWidth` / `Layout.fillHeight`
- `Layout.preferredWidth` / `Layout.preferredHeight`
- `Layout.minimumWidth` / `Layout.minimumHeight`
- `Layout.maximumWidth` / `Layout.maximumHeight`
- `Layout.alignment`
- `Layout.rowSpan` / `Layout.columnSpan` (for `GridLayout`)

**Do:**
- Size the layout itself with anchors or explicit `width`/`height` against its non-layout parent.
- Use `Layout` attached properties for immediate children.

**Don't:**
- Use anchors on an item that is an immediate child of a layout.
- Override `preferred` sizes for items that already have satisfactory `implicitWidth`/`implicitHeight`.

### Choosing anchors/positioners vs layouts

- Use simple `x`/`y`/`width`/`height` bindings when possible (fastest, least memory).
- Use anchors/positioners for static arrangements.
- Use layouts when children must resize with the window.
- Avoid layouts and anchors inside list/table delegates or control styles when simple bindings suffice.

## Handling User Input

### Pointer events

Modern Qt Quick uses input handlers such as `TapHandler`:

```qml
Rectangle {
    TapHandler {
        onTapped: rectangle.width += 10
    }
}
```

Some items have built-in input handling (e.g., `Flickable` handles dragging and flicking).

### Keyboard events

Use the `Keys` attached property together with `focus`:

```qml
Rectangle {
    focus: true
    Keys.onUpPressed: y -= 10
    Keys.onDownPressed: y += 10
}
```

### Text input

| Type | Use case |
|------|----------|
| `TextInput` | Unstyled single-line editable text |
| `TextEdit` | Unstyled multi-line editable text |
| `TextField` | Styled single-line form field (Qt Quick Controls) |
| `TextArea` | Styled multi-line text area (Qt Quick Controls) |

## Displaying Text

Use `Text` with the `text` property:

```qml
Text {
    text: "Hello, QML!"
    color: "yellow"
    font { family: "Courier"; pixelSize: 20; italic: true }
    wrapMode: Text.WordWrap
    width: parent.width
}
```

- `textFormat`: `Text.PlainText`, `Text.StyledText` (efficient HTML-like subset), `Text.RichText` (full Qt rich text).
- `wrapMode` requires explicit `width`.
- Use `paintedWidth` / `paintedHeight` when width/height are not explicitly set.

## Animations, States, and Transitions

### States and transitions

Declare states with `State` and animate between them with `Transition`:

```qml
Item {
    id: container
    states: [
        State {
            name: "other"
            PropertyChanges { target: rect; x: 200 }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { properties: "x,y" }
        }
    ]
}
```

### Behaviors

A `Behavior` animates any change to a property:

```qml
Rectangle {
    Behavior on x {
        NumberAnimation { duration: 600; easing.type: Easing.OutBounce }
    }
    TapHandler {
        onTapped: parent.x = parent.x === 0 ? 200 : 0
    }
}
```

### Animation types

Common animation types:

| Type | Purpose |
|------|---------|
| `NumberAnimation` | Animate numeric properties |
| `ColorAnimation` | Animate colors |
| `PropertyAnimation` | Generic property animation |
| `SequentialAnimation` | Run animations in sequence |
| `ParallelAnimation` | Run animations in parallel |
| `PauseAnimation` | Insert a delay |

Property-level animations run automatically. Standalone animations run only when `running` is set or started explicitly.

```qml
Rectangle {
    SequentialAnimation on x {
        loops: Animation.Infinite
        NumberAnimation { to: 150; duration: 1000 }
        NumberAnimation { to: 0; duration: 1000 }
    }
}
```

## Related Qt Quick Modules

| Module | Import | Purpose |
|--------|--------|---------|
| Qt Quick Controls | `QtQuick.Controls` | Buttons, menus, sliders, application windows, styled controls |
| Qt Quick Layouts | `QtQuick.Layouts` | Resizing layouts (`RowLayout`, `ColumnLayout`, `GridLayout`) |
| Qt Quick Dialogs | `QtQuick.Dialogs` | File/color/font/message dialogs |
| Qt Quick Particles | `QtQuick.Particles` | Particle effects |
| Qt Quick Shapes | `QtQuick.Shapes` | Vector shapes |
| Qt Quick Local Storage | `QtQuick.LocalStorage` | SQLite wrapper for JS |
| Qt Quick Test | `QtQuick.Test` | QML unit testing |

## Quick Shell / Application Notes

For building desktop shell components (panels, widgets, etc.) with a QML-based shell framework, the same Qt Quick patterns apply: `Window` or `ApplicationWindow` as the root, `RowLayout`/`ColumnLayout` for panel geometry, `TapHandler` for interactions, and `ListView`/`Repeater` for dynamic items. Shell-specific windowing and IPC types are covered by the framework's own skill.

[Sources: https://doc.qt.io/qt-6/qtquick-usecase-visual.html, https://doc.qt.io/qt-6/qtquick-usecase-layouts.html, https://doc.qt.io/qt-6/qtquick-usecase-userinput.html, https://doc.qt.io/qt-6/qtquick-usecase-text.html, https://doc.qt.io/qt-6/qtquick-usecase-animations.html]
