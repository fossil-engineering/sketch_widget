part of 'draft_widget.dart';

class _HoverWidget extends StatelessWidget {
  const _HoverWidget({
    required this.position,
    required this.scale,
  });

  final Rect position;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: position,
      child: IgnorePointer(
        child: CustomPaint(
          painter: _HoverPainter(scale),
        ),
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

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..lineTo(0, 0)
        ..close(),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
