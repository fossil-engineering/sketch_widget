part of 'draft_widget.dart';

const _cursors = [
  SystemMouseCursors.resizeUpLeftDownRight,
  SystemMouseCursors.resizeUpDown,
  SystemMouseCursors.resizeUpRightDownLeft,
  SystemMouseCursors.resizeLeftRight,
  SystemMouseCursors.resizeUpLeftDownRight,
  SystemMouseCursors.resizeUpDown,
  SystemMouseCursors.resizeUpRightDownLeft,
  SystemMouseCursors.resizeLeftRight,
];

class _ControlWidget extends StatelessWidget with _Resize, _Rotate {
  _ControlWidget({
    required this.positionState,
    required this.angleState,
    required this.scaleState,
    required ValueNotifier<bool> transformingState,
    required ValueNotifier<int> hoverState,
    required ValueNotifier<Rect?> hoverPosition,
    required ValueNotifier<Rect?> focusPosition,
    required ValueNotifier<bool> lockRatio,
    required ValueNotifier<Matrix4> transformState,
    required this.rotateState,
    required this.onEnd,
  }) {
    this.transformingState = transformingState;
    this.hoverState = hoverState;
    this.hoverPosition = hoverPosition;
    this.focusPosition = focusPosition;
    this.lockRatio = lockRatio;
    this.transformState = transformState;
  }

  final ValueNotifier<Rect?> positionState;
  final ValueNotifier<double> angleState;
  final ValueNotifier<double> scaleState;
  final ValueNotifier<bool> rotateState;
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
            child: ValueListenableBuilder<bool>(
              valueListenable: rotateState,
              builder: (_, rotate, __) => ValueListenableBuilder<Matrix4>(
                valueListenable: transformState,
                builder: (_, transform, __) {
                  final angle = angleState.value;
                  final startIndex = rotate
                      ? 0
                      : (((degrees(angle) % 360 + 360) % 360) ~/ 22.5 + 1) ~/ 2;
                  return Transform.rotate(
                    angle: angle,
                    child: Transform(
                      transform: transform,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _PositionedWidget(
                            center: Offset.zero,
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[startIndex % 8],
                            onUpdate:
                                rotate ? _onTopLeftRotate : _onTopLeftResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(position.width / 2, 0),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 1) % 8],
                            onUpdate: rotate ? _onTopRotate : _onTopResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(position.width, 0),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 2) % 8],
                            onUpdate:
                                rotate ? _onTopRightRotate : _onTopRightResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(position.width, position.height / 2),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 3) % 8],
                            onUpdate: rotate ? _onRightRotate : _onRightResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(position.width, position.height),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 4) % 8],
                            onUpdate: rotate
                                ? _onBottomRightRotate
                                : _onBottomRightResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(position.width / 2, position.height),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 5) % 8],
                            onUpdate:
                                rotate ? _onBottomRotate : _onBottomResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(0, position.height),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 6) % 8],
                            onUpdate: rotate
                                ? _onBottomLeftRotate
                                : _onBottomLeftResize,
                            onEnd: onEnd,
                          ),
                          _PositionedWidget(
                            center: Offset(0, position.height / 2),
                            scaleX: scale * transform.getScaleX(),
                            scaleY: scale * transform.getScaleY(),
                            cursor: rotate
                                ? SystemMouseCursors.grab
                                : _cursors[(startIndex + 7) % 8],
                            onUpdate: rotate ? _onLeftRotate : _onLeftResize,
                            onEnd: onEnd,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      child: const _ZeroPositioned(),
    );
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
