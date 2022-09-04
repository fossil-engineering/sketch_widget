part of 'draft_widget.dart';

final _quaternionIdentity = Quaternion.identity();
final _translationZero = Vector3.zero();
final _translationVector3 = Vector3.zero();
final _scaleVector3 = Vector3.zero();

class _ControlWidget extends StatelessWidget {
  const _ControlWidget({
    required this.positionState,
    required this.scaleState,
    required this.transformingState,
    required this.hoverState,
    required this.hoverPosition,
    required this.focusPosition,
    required this.lockRatio,
    required this.transformState,
    required this.onEnd,
  });

  final ValueNotifier<Rect?> positionState;
  final ValueNotifier<double> scaleState;
  final ValueNotifier<bool> transformingState;
  final ValueNotifier<int> hoverState;
  final ValueNotifier<Rect?> hoverPosition;
  final ValueNotifier<Rect?> focusPosition;
  final ValueNotifier<bool> lockRatio;
  final ValueNotifier<Matrix4> transformState;
  final void Function() onEnd;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Rect?>(
      valueListenable: positionState,
      builder: (_, position, child) {
        if (position == null) return child!;
        return ValueListenableBuilder<double>(
          valueListenable: scaleState,
          builder: (_, scale, __) => Positioned.fromRect(
            rect: position,
            child: ValueListenableBuilder<Matrix4>(
              valueListenable: transformState,
              builder: (_, transform, __) {
                return Transform.rotate(
                  angle: 0,
                  child: Transform(
                    transform: transform,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _PositionedWidget(
                          center: Offset.zero,
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeUpLeftDownRight,
                          onUpdate: _onTopLeftUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(position.width / 2, 0),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeUpDown,
                          onUpdate: _onTopUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(position.width, 0),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeUpRightDownLeft,
                          onUpdate: _onTopRightUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(position.width, position.height / 2),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeLeftRight,
                          onUpdate: _onRightUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(position.width, position.height),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeUpLeftDownRight,
                          onUpdate: _onBottomRightUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(position.width / 2, position.height),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeUpDown,
                          onUpdate: _onBottomUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(0, position.height),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeUpRightDownLeft,
                          onUpdate: _onBottomLeftUpdate,
                          onEnd: onEnd,
                        ),
                        _PositionedWidget(
                          center: Offset(0, position.height / 2),
                          scaleX: scale * transform.getScaleX(),
                          scaleY: scale * transform.getScaleY(),
                          cursor: SystemMouseCursors.resizeLeftRight,
                          onUpdate: _onLeftUpdate,
                          onEnd: onEnd,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: const _ZeroPositioned(),
    );
  }

  void _onTopLeftUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value ? offset.intersect(rect.size) : offset;
      _scaleVector3.setValues(
        (rect.width - newOffset.dx) / rect.width,
        (rect.height - newOffset.dy) / rect.height,
        1,
      );
      _translationVector3.setValues(newOffset.dx, newOffset.dy, 0);
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onTopUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.height - offset.dy) / rect.height;
      _scaleVector3.setValues(
        lockRatio.value ? scale : 1,
        scale,
        1,
      );
      _translationVector3.setValues(
        lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
        offset.dy,
        0,
      );
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onTopRightUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value
          ? offset.intersect(Size(-rect.width, rect.height))
          : offset;
      _scaleVector3.setValues(
        (rect.width + newOffset.dx) / rect.width,
        (rect.height - newOffset.dy) / rect.height,
        1,
      );
      _translationVector3.setValues(0, newOffset.dy, 0);
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onRightUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.width + offset.dx) / rect.width;
      _scaleVector3.setValues(
        scale,
        lockRatio.value ? scale : 1,
        1,
      );
      _translationVector3.setValues(
        0,
        lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
        0,
      );
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onBottomRightUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value ? offset.intersect(rect.size) : offset;
      _scaleVector3.setValues(
        (rect.width + newOffset.dx) / rect.width,
        (rect.height + newOffset.dy) / rect.height,
        1,
      );
      transformState.value = Matrix4.compose(
        _translationZero,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onBottomUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.height + offset.dy) / rect.height;
      _scaleVector3.setValues(
        lockRatio.value ? scale : 1,
        scale,
        1,
      );
      _translationVector3.setValues(
        lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
        0,
        0,
      );
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onBottomLeftUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final newOffset = lockRatio.value
          ? offset.intersect(Size(-rect.width, rect.height))
          : offset;
      _scaleVector3.setValues(
        (rect.width - newOffset.dx) / rect.width,
        (rect.height + newOffset.dy) / rect.height,
        1,
      );
      _translationVector3.setValues(newOffset.dx, 0, 0);
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _onLeftUpdate(Offset offset) {
    _transforming();
    focusPosition.value?.let((rect) {
      final scale = (rect.width - offset.dx) / rect.width;
      _scaleVector3.setValues(
        scale,
        lockRatio.value ? scale : 1,
        1,
      );
      _translationVector3.setValues(
        offset.dx,
        lockRatio.value ? (rect.width - rect.width * scale) / 2 : 0,
        0,
      );
      transformState.value = Matrix4.compose(
        _translationVector3,
        _quaternionIdentity,
        _scaleVector3,
      );
    });
  }

  void _transforming() {
    transformingState.value = true;
    hoverState.value = noPosition;
    hoverPosition.value = null;
  }
}

class _PositionedWidget extends StatelessWidget {
  const _PositionedWidget({
    required this.center,
    required this.scaleX,
    required this.scaleY,
    required this.cursor,
    required this.onUpdate,
    required this.onEnd,
  });

  final Offset center;
  final double scaleX;
  final double scaleY;
  final MouseCursor cursor;
  final void Function(Offset) onUpdate;
  final void Function() onEnd;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: center,
        width: 16 / scaleX,
        height: 16 / scaleY,
      ),
      child: GestureDetector(
        onPanUpdate: (details) => onUpdate(details.localPosition),
        onPanEnd: (_) => onEnd(),
        child: MouseRegion(
          cursor: cursor,
          child: Container(
            width: 16 / scaleX,
            height: 16 / scaleY,
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              width: 4 / scaleX,
              height: 4 / scaleY,
            ),
          ),
        ),
      ),
    );
  }
}
