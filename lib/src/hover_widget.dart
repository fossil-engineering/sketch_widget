part of 'draft_widget.dart';

class _HoverWidget extends StatelessWidget {
  const _HoverWidget({required this.positionState, required this.scaleState});

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
            child: IgnorePointer(
              child: CustomPaint(painter: _HoverPainter(scale)),
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

class _HoverPainter extends CustomPainter {
  _HoverPainter(this.scale);

  final double scale;

  late final _paint = Paint()
    ..color = Colors.orange
    ..strokeWidth = 2 / scale
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
