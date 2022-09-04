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
  DraftWidget({
    required this.sketch,
    ValueNotifier<int>? hoverState,
    ValueNotifier<int>? focusState,
    ValueNotifier<bool>? lockRatio,
    this.onTransform,
    super.key,
  })  : _hoverState = hoverState ?? ValueNotifier(noPosition),
        _focusState = focusState ?? ValueNotifier(noPosition),
        _lockRatio = lockRatio ?? ValueNotifier(true);

  /// Widgets will be drafted.
  final Map<int, Map<String, dynamic>> sketch;

  /// Callback when end transforming.
  final void Function(Rect)? onTransform;

  final ValueNotifier<int> _hoverState;

  final ValueNotifier<int> _focusState;

  final ValueNotifier<bool> _lockRatio;

  @override
  Widget build(BuildContext context) {
    final hoverPosition = ValueNotifier<Rect?>(_position(_hoverState.value));
    final focusPosition = ValueNotifier<Rect?>(_position(_focusState.value));
    final controller = TransformationController();
    final scaleState = ValueNotifier<double>(1);
    final transformState = ValueNotifier<Matrix4>(Matrix4.identity());
    final transformingState = ValueNotifier<bool>(false);

    return GestureDetector(
      onTap: () {
        if (_focusState.value != noPosition) {
          _focusState.value = noPosition;
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
                focusState: _focusState,
                hoverPosition: hoverPosition,
                hoverState: _hoverState,
                transformingState: transformingState,
                position: e.value['position'] as Rect,
                child: e.value['widget'] as Widget,
                onEnd: () => onTransform?.call(
                  transformState.value.transformRect(focusPosition.value!),
                ),
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
              hoverState: _hoverState,
              hoverPosition: hoverPosition,
              focusPosition: focusPosition,
              lockRatio: _lockRatio,
              transformState: transformState,
              onEnd: () => onTransform?.call(
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
