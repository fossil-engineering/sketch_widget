# draft_widget

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

Flutter widget to draft widgets

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis


## Features

- Translate
- Scale
- Rotate

## Getting started

```yaml
dependencies:
  draft_widget: ^1.0.0
```

## Usage

```dart
DraftWidget(
    sketch: {
        1: {
            'position': const Rect.fromLTWH(150, 150, 304, 304),
            'widget': Image.asset('images/ending_dash.png', fit: BoxFit.cover),
            'angle': pi / 4,
        },
    },
);
```

![](https://raw.githubusercontent.com/de-men/draft_widget/main/readme_images/screenshot.png)

## Additional information

Feel free to give feedback.