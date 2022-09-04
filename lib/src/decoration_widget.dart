part of 'draft_widget.dart';

class _DecorationWidget extends StatelessWidget {
  const _DecorationWidget({
    required this.positionState,
    required this.scaleState,
    required this.transformState,
    required this.color,
    required this.strokeWidth,
  });

  final ValueNotifier<Rect?> positionState;
  final ValueNotifier<double> scaleState;
  final ValueNotifier<Matrix4> transformState;
  final Color color;
  final double strokeWidth;

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
            child: IgnorePointer(
              child: ValueListenableBuilder<Matrix4>(
                valueListenable: transformState,
                builder: (_, transform, __) => Transform(
                  transform: transform,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color,
                        width: strokeWidth / scale,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: const _ZeroPositioned(),
    );
  }
}

class _ZeroPositioned extends StatelessWidget {
  const _ZeroPositioned();

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.zero,
      child: const SizedBox.shrink(),
    );
  }
}
