import 'package:flutter/material.dart';

part 'transform_widget.dart';

part 'hover_widget.dart';

part 'focus_widget.dart';

/// No position index
const noPosition = -1;

/// DraftWidget to draft widgets
class DraftWidget extends StatelessWidget {
  /// DraftWidget Constructor
  const DraftWidget({
    required this.hover,
    required this.focus,
    required this.sketch,
    super.key,
  });

  /// Hover state contain index of element that is hovered.
  final ValueNotifier<int> hover;

  /// Focus state contain index of element that is focused.
  final ValueNotifier<int> focus;

  /// Widgets will be drafted.
  final Map<int, Map<String, dynamic>> sketch;

  @override
  Widget build(BuildContext context) {
    final hoverPosition = ValueNotifier<Rect?>(null);
    final focusPosition = ValueNotifier<Rect?>(null);
    final controller = TransformationController();
    final scaleState = ValueNotifier<double>(1);

    return GestureDetector(
      onTap: () {
        if (focus.value != noPosition) {
          focus.value = noPosition;
          focusPosition.value = null;
        }
      },
      child: InteractiveViewer(
        transformationController: controller,
        onInteractionUpdate: (_) {
          scaleState.value = controller.value.getMaxScaleOnAxis();
        },
        child: Stack(
          children: [
            ...sketch.entries.map(
              (e) {
                final position = e.value['position'] as Rect;
                return Positioned.fromRect(
                  rect: position,
                  child: _TransformWidget(
                    onTap: () {
                      if (focus.value != e.key) {
                        focus.value = e.key;
                        focusPosition.value = position;
                      }
                    },
                    onEnter: () {
                      if (hover.value != e.key) {
                        hover.value = e.key;
                        hoverPosition.value = position;
                      }
                    },
                    onExit: () {
                      if (hover.value == e.key) {
                        hover.value = noPosition;
                        hoverPosition.value = null;
                      }
                    },
                    child: e.value['widget'] as Widget,
                  ),
                );
              },
            ),
            _FocusWidget(positionState: focusPosition, scaleState: scaleState),
            _HoverWidget(positionState: hoverPosition, scaleState: scaleState),
          ],
        ),
      ),
    );
  }
}
