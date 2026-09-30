---
description: Core QML language concepts, Qt Quick type patterns, and effective QML design principles for building shell and application UIs.
---

# QML Overview

QML (Qt Meta Language) is a declarative language for describing dynamic user interfaces. With a JSON-like syntax and first-class property bindings, QML lets you declare object trees and relationships, while imperative behavior is supplied through JavaScript expressions and signal handlers. The `QtQuick` module provides the standard library of visual, input, layout, animation, and text types used to build most QML applications.

Reach for this skill when:
- You need to write or review QML code for a shell, widget, or application UI.
- You are deciding how to structure QML types, handle user input, or integrate JavaScript.
- You need to debug binding, type, layout, or performance problems in QML.

For framework-specific shell APIs (windowing, IPC, system services, etc.), consult the project's Quickshell or shell-specific skill.

## Reference Files

- `ref/qml-language-basics.md` — document structure, imports, object attributes, property bindings, and the signal/handler event system.
- `ref/qml-type-system.md` — object types vs value types, enumerations, sequences, singletons, attached types, and defining custom QML types.
- `ref/qt-quick-types.md` — visual types, positioning/anchoring, layouts, user input, text, animation, state, and transition patterns.
- `ref/qml-javascript-integration.md` — using JavaScript in bindings and handlers, importing `.js`/`.mjs` resources, dynamic object creation, and the QML global object.
- `ref/qml-principles-and-pitfalls.md` — coding conventions, separation of UI/logic, layout guidelines, type safety, and performance best practices.

[Source: https://doc.qt.io/qt-6/qmlapplications.html]
