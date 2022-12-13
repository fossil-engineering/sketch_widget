part of 'sketch_widget.dart';

mixin _Rotate {
  late final ValueNotifier<bool> transformingState;
  late final ValueNotifier<int> hoverState;
  late final ValueNotifier<Rect?> hoverPosition;
  late final ValueNotifier<Rect?> focusPosition;
  late final ValueNotifier<bool> lockRatio;
  late final ValueNotifier<Matrix4> transformState;

  void _onTopLeftRotate(Offset offset) => _onRotate(0, 0, offset);

  void _onTopRotate(Offset offset) => _onRotate(0.5, 0, offset);

  void _onTopRightRotate(Offset offset) => _onRotate(1, 0, offset);

  void _onRightRotate(Offset offset) => _onRotate(1, 0.5, offset);

  void _onBottomRightRotate(Offset offset) => _onRotate(1, 1, offset);

  void _onBottomRotate(Offset offset) => _onRotate(0.5, 1, offset);

  void _onBottomLeftRotate(Offset offset) => _onRotate(0, 1, offset);

  void _onLeftRotate(Offset offset) => _onRotate(0, 0.5, offset);

  void _onRotate(double x, double y, Offset o2) {
    transformingState.value = true;
    hoverState.value = noPosition;
    hoverPosition.value = null;
    final rect = focusPosition.value!;
    final o1 = Offset(rect.width * x, rect.height * y);
    transformState.value = transformState.value.clone()
      ..translate(rect.width / 2, rect.height / 2)
      ..setRotationZ(Offset(rect.width / 2, rect.height / 2).angle(o1, o1 + o2))
      ..translate(-rect.width / 2, -rect.height / 2);
  }
}
