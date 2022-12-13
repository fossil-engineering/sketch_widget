# sketch_widget

![Build](https://github.com/fossil-engineering/sketch_widget/workflows/CI/badge.svg)
[![pub package](https://img.shields.io/pub/v/sketch_widget.svg)](https://pub.dev/packages/sketch_widget)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

Flutter widget to sketch widgets

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

## Features

- Translate
- Scale
- Rotate
- Visibility
- Lock

## Getting started

```yaml
dependencies:
  sketch_widget: ^1.2.1
```

## Usage

```dart
SketchWidget(
    sketch: {
        2: {
            Component.position: const Rect.fromLTWH(100, 100, 100, 100),
            Component.widget: const ColoredBox(color: Colors.red),
            Component.angle: pi / 2,
        },
        1: {
            Component.position: const Rect.fromLTWH(150, 150, 200, 200),
            Component.widget: Image.asset('images/ending_dash.png'),
            Component.angle: pi / 4,
        },
        3: {
            Component.position: const Rect.fromLTWH(200, 200, 50, 50),
            Component.widget: const ColoredBox(color: Colors.blue),
            Component.lock: true,
        },
        4: {
            Component.position: const Rect.fromLTWH(250, 250, 50, 50),
            Component.widget: const ColoredBox(color: Colors.yellow),
            Component.visibility: false,
        },
    },
);
```

![](https://raw.githubusercontent.com/fossil-engineering/sketch_widget/main/readme_images/screenshot.png)

## Additional information

Feel free to give feedback.