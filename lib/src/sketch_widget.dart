import 'package:flutter/material.dart';
import 'package:sketch_widget/sketch_widget.dart';
import 'package:sketch_widget/src/util.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

part 'control_widget.dart';

part 'decoration_widget.dart';

part 'resize_mixin.dart';

part 'rotate_mixin.dart';

part 'transform_widget.dart';

/// No position index
const noPosition = -1;

/// Callback when the transformation done with focusId and their info
typedef OnTransform = void Function(int, Rect, double);

/// SketchWidget to sketch widgets
class SketchWidget extends StatelessWidget {
  /// SketchWidget Constructor
  SketchWidget({
    required this.sketch,
    ValueNotifier<int>? hoverState,
    ValueNotifier<int>? focusState,
    ValueNotifier<bool>? lockRatio,
    ValueNotifier<bool>? rotate,
    this.onTransform,
    super.key,
  })  : _hoverState = hoverState ?? ValueNotifier(noPosition),
        _focusState = focusState ?? ValueNotifier(noPosition),
        _rotate = rotate ?? ValueNotifier(true),
        _lockRatio = lockRatio ?? ValueNotifier(true);

  /// Widgets will be sketched.
  final Map<int, Map<Component, dynamic>> sketch;

  /// Callback when end transforming.
  final OnTransform? onTransform;

  final ValueNotifier<int> _hoverState;

  final ValueNotifier<int> _focusState;

  final ValueNotifier<bool> _rotate;

  final ValueNotifier<bool> _lockRatio;

  @override
  Widget build(BuildContext context) {
    final focusPosition = ValueNotifier<Rect?>(_position(_focusState.value));
    final focusAngle = ValueNotifier<double>(_angle(_focusState.value));
    final hoverPosition = ValueNotifier<Rect?>(_position(_hoverState.value));
    final hoverAngle = ValueNotifier<double>(_angle(_hoverState.value));
    final controller = TransformationController();
    final scaleState = ValueNotifier<double>(1);
    final transformState = ValueNotifier<Matrix4>(Matrix4.identity());
    final transformingState = ValueNotifier<bool>(false);
    final lockFocus = ValueNotifier<bool>(
      sketch[_focusState.value]?.let((it) => it['lock'] as bool?) ?? false,
    );

    return GestureDetector(
      onTap: () {
        if (_focusState.value != noPosition) {
          _focusState.value = noPosition;
          focusPosition.value = null;
        }
      },
      child: InteractiveViewer(
        transformationController: controller,
        onInteractionUpdate: (_) => scaleState.value = controller.value.scaleX,
        child: Stack(
          children: [
            ...sketch.entries.where((element) {
              return element.value[Component.visibility] != false;
            }).map(
              (e) => _TransformWidget(
                id: e.key,
                transformState: transformState,
                focusPosition: focusPosition,
                focusAngle: focusAngle,
                focusState: _focusState,
                hoverPosition: hoverPosition,
                hoverAngle: hoverAngle,
                hoverState: _hoverState,
                transformingState: transformingState,
                position: e.value[Component.position] as Rect,
                angle: e.value[Component.angle] as double? ?? 0.0,
                lock: e.value[Component.lock] as bool? ?? false,
                lockFocus: lockFocus,
                onEnd: () => _onTransform(
                  transformState.value,
                  focusPosition.value!,
                  focusAngle.value,
                ),
                child: e.value[Component.widget] as Widget,
              ),
            ),
            _DecorationWidget(
              positionState: focusPosition,
              angleState: focusAngle,
              scaleState: scaleState,
              transformState: transformState,
              color: Colors.white,
              strokeWidth: 0.5,
            ),
            _DecorationWidget(
              positionState: hoverPosition,
              angleState: hoverAngle,
              scaleState: scaleState,
              transformState: transformState,
              color: Colors.orange,
              strokeWidth: 2,
            ),
            _ControlWidget(
              positionState: focusPosition,
              angleState: focusAngle,
              scaleState: scaleState,
              transformingState: transformingState,
              hoverState: _hoverState,
              hoverPosition: hoverPosition,
              focusPosition: focusPosition,
              lockRatio: _lockRatio,
              lockFocus: lockFocus,
              transformState: transformState,
              rotateState: _rotate,
              onEnd: () => _onTransform(
                transformState.value,
                focusPosition.value!,
                focusAngle.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Rect? _position(int key) {
    return sketch.containsKey(key)
        ? sketch[key]![Component.position] as Rect
        : null;
  }

  double _angle(int key) => sketch[key]?[Component.angle] as double? ?? 0.0;

  void _onTransform(Matrix4 matrix4, Rect rect, double angle) {
    final transform = Matrix4.translationValues(
      rect.left + rect.width / 2,
      rect.top + rect.height / 2,
      0,
    )
      ..rotateZ(angle)
      ..translate(-rect.width / 2, -rect.height / 2)
      ..multiply(matrix4)
      ..translate(-rect.left, -rect.top);

    onTransform?.call(
      _focusState.value,
      Rect.fromCenter(
        center: MatrixUtils.transformPoint(transform, rect.center),
        width: rect.width * transform.scaleX,
        height: rect.height * transform.scaleY,
      ),
      transform.rotationZ,
    );
  }
}
