import 'package:draft_widget/src/util.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

part 'control_widget.dart';
part 'decoration_widget.dart';
part 'transform_widget.dart';

/// No position index
const noPosition = -1;

/// DraftWidget to draft widgets
class DraftWidget extends StatelessWidget {
  /// DraftWidget Constructor
  const DraftWidget({
    required this.hoverState,
    required this.focusState,
    required this.sketch,
    required this.lockRatio,
    required this.onTransform,
    super.key,
  });

  /// Hover state contain index of element that is hovered.
  final ValueNotifier<int> hoverState;

  /// Focus state contain index of element that is focused.
  final ValueNotifier<int> focusState;

  /// LockRatio state contain true if we lock ratio when resize.
  final ValueNotifier<bool> lockRatio;

  /// Widgets will be drafted.
  final Map<int, Map<String, dynamic>> sketch;

  /// Callback when end transforming.
  final void Function(Rect) onTransform;

  @override
  Widget build(BuildContext context) {
    final hoverPosition = ValueNotifier<Rect?>(_position(hoverState.value));
    final focusPosition = ValueNotifier<Rect?>(_position(focusState.value));
    final controller = TransformationController();
    final scaleState = ValueNotifier<double>(1);
    final transformState = ValueNotifier<Matrix4>(Matrix4.identity());
    final transformingState = ValueNotifier<bool>(false);

    return GestureDetector(
      onTap: () {
        if (focusState.value != noPosition) {
          focusState.value = noPosition;
          focusPosition.value = null;
        }
      },
      child: InteractiveViewer(
        transformationController: controller,
        onInteractionUpdate: (_) {
          scaleState.value = controller.value.getScaleX();
        },
        child: Stack(
          children: [
            ...sketch.entries.map(
              (e) => _TransformWidget(
                id: e.key,
                transformState: transformState,
                focusPosition: focusPosition,
                focusState: focusState,
                hoverPosition: hoverPosition,
                hoverState: hoverState,
                transformingState: transformingState,
                position: e.value['position'] as Rect,
                child: e.value['widget'] as Widget,
              ),
            ),
            _DecorationWidget(
              positionState: focusPosition,
              scaleState: scaleState,
              transformState: transformState,
              color: Colors.white,
              strokeWidth: 0.5,
            ),
            _DecorationWidget(
              positionState: hoverPosition,
              scaleState: scaleState,
              transformState: transformState,
              color: Colors.orange,
              strokeWidth: 2,
            ),
            _ControlWidget(
              positionState: focusPosition,
              scaleState: scaleState,
              transformingState: transformingState,
              hoverState: hoverState,
              hoverPosition: hoverPosition,
              focusPosition: focusPosition,
              lockRatio: lockRatio,
              transformState: transformState,
              onEnd: () => onTransform(
                transformState.value.transformRect(focusPosition.value!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Rect? _position(int key) {
    return sketch.containsKey(key) ? sketch[key]!['position'] as Rect : null;
  }
}
