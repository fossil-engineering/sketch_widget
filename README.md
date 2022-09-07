# draft_widget

![Build](https://github.com/fossil-engineering/draft_widget/workflows/CI/badge.svg)
[![pub package](https://img.shields.io/pub/v/draft_widget.svg)](https://pub.dev/packages/draft_widget)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

Flutter widget to draft widgets

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
  draft_widget: ^1.2.0
```

## Usage

```dart
DraftWidget(
    sketch: {
        2: {
            'position': const Rect.fromLTWH(100, 100, 100, 100),
            'widget': const ColoredBox(color: Colors.red),
            'angle': pi / 2,
        },
        1: {
            'position': const Rect.fromLTWH(150, 150, 200, 200),
            'widget': Image.asset('images/ending_dash.png'),
            'angle': pi / 4,
        },
        3: {
            'position': const Rect.fromLTWH(200, 200, 50, 50),
            'widget': const ColoredBox(color: Colors.blue),
            'lock': true,
        },
        4: {
            'position': const Rect.fromLTWH(250, 250, 50, 50),
            'widget': const ColoredBox(color: Colors.yellow),
            'visibility': false,
        },
    },
);
```

![](https://raw.githubusercontent.com/de-men/draft_widget/main/readme_images/screenshot.png)

## Additional information

Feel free to give feedback.