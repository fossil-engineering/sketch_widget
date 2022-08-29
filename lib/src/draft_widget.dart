import 'package:flutter/material.dart';

part 'focus_widget.dart';

part 'transform_widget.dart';

/// DraftWidget to draft widgets
class DraftWidget extends StatelessWidget {
  /// DraftWidget Constructor
  const DraftWidget({required this.sketch, super.key});

  /// Widgets will be drafted.
  final List<Map<String, dynamic>> sketch;

  @override
  Widget build(BuildContext context) {
    final controller = TransformationController();
    return InteractiveViewer(
      transformationController: controller,
      child: Stack(
        children: sketch.map(
          (e) {
            final position = e['position'] as Rect;
            return Positioned.fromRect(
              rect: position,
              child: _FocusWidget(
                width: position.width,
                height: position.height,
                matrix4: controller.value,
                child: e['widget'] as Widget,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
