part of 'draft_widget.dart';

class _FocusWidget extends StatelessWidget {
  const _FocusWidget({required this.positionState, required this.scaleState});

  final ValueNotifier<Rect?> positionState;
  final ValueNotifier<double> scaleState;

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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fromRect(
                  rect: Rect.fromLTWH(0, 0, position.width, position.height),
                  child: IgnorePointer(
                    child: CustomPaint(painter: _FocusPainter(scale)),
                  ),
                ),
              ],
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

class _FocusPainter extends CustomPainter {
  _FocusPainter(this.scale);

  final double scale;

  late final _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 1 / scale
    ..style = PaintingStyle.stroke;
  final _path = Path();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _path
        ..reset()
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
