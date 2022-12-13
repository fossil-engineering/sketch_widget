part of 'sketch_widget.dart';

final _quaternionIdentity = Quaternion.identity();
final _vector3Zero = Vector3.zero();

mixin _Resize {
  late final ValueNotifier<bool> transformingState;
  late final ValueNotifier<int> hoverState;
  late final ValueNotifier<Rect?> hoverPosition;
  late final ValueNotifier<Rect?> focusPosition;
  late final ValueNotifier<bool> lockRatio;
  late final ValueNotifier<Matrix4> transformState;

  void _onTopLeftResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value ? offset.intersect(rect.size) : offset;
      transformState.value = Matrix4.compose(
        Vector3(newOffset.dx, newOffset.dy, 0),
        _quaternionIdentity,
        Vector3(
          (rect.width - newOffset.dx) / rect.width,
          (rect.height - newOffset.dy) / rect.height,
          1,
        ),
      );
    });
  }

  void _onTopResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.height - offset.dy) / rect.height;
      transformState.value = Matrix4.compose(
        Vector3(
          lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
          offset.dy,
          0,
        ),
        _quaternionIdentity,
        Vector3(lockRatio.value ? scale : 1, scale, 1),
      );
    });
  }

  void _onTopRightResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value
          ? offset.intersect(Size(-rect.width, rect.height))
          : offset;
      transformState.value = Matrix4.compose(
        Vector3(0, newOffset.dy, 0),
        _quaternionIdentity,
        Vector3(
          (rect.width + newOffset.dx) / rect.width,
          (rect.height - newOffset.dy) / rect.height,
          1,
        ),
      );
    });
  }

  void _onRightResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.width + offset.dx) / rect.width;
      transformState.value = Matrix4.compose(
        Vector3(
          0,
          lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
          0,
        ),
        _quaternionIdentity,
        Vector3(scale, lockRatio.value ? scale : 1, 1),
      );
    });
  }

  void _onBottomRightResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value ? offset.intersect(rect.size) : offset;
      transformState.value = Matrix4.compose(
        _vector3Zero,
        _quaternionIdentity,
        Vector3(
          (rect.width + newOffset.dx) / rect.width,
          (rect.height + newOffset.dy) / rect.height,
          1,
        ),
      );
    });
  }

  void _onBottomResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.height + offset.dy) / rect.height;
      transformState.value = Matrix4.compose(
        Vector3(
          lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
          0,
          0,
        ),
        _quaternionIdentity,
        Vector3(lockRatio.value ? scale : 1, scale, 1),
      );
    });
  }

  void _onBottomLeftResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value
          ? offset.intersect(Size(-rect.width, rect.height))
          : offset;
      transformState.value = Matrix4.compose(
        Vector3(newOffset.dx, 0, 0),
        _quaternionIdentity,
        Vector3(
          (rect.width - newOffset.dx) / rect.width,
          (rect.height + newOffset.dy) / rect.height,
          1,
        ),
      );
    });
  }

  void _onLeftResize(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.width - offset.dx) / rect.width;
      transformState.value = Matrix4.compose(
        Vector3(
          offset.dx,
          lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
          0,
        ),
        _quaternionIdentity,
        Vector3(scale, lockRatio.value ? scale : 1, 1),
      );
    });
  }

  void _transforming() {
    transformingState.value = true;
    hoverState.value = noPosition;
    hoverPosition.value = null;
  }
}
