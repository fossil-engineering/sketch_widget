part of 'draft_widget.dart';

class _DecorationWidget extends StatelessWidget {
  const _DecorationWidget({
    required this.positionState,
    required this.scaleState,
    required this.color,
    required this.strokeWidth,
  });

  final ValueNotifier<Rect?> positionState;
  final ValueNotifier<double> scaleState;
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: strokeWidth / scale),
                ),
              ),
            ),
          ),
        );
      },
      child: Positioned.fromRect(
        rect: Rect.zero,
        child: const SizedBox.shrink(),
      ),
    );
  }
}
