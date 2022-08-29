part of 'draft_widget.dart';

class _TransformWidget extends StatefulWidget {
  const _TransformWidget({
    required this.child,
    required this.width,
    required this.height,
    required this.matrix4,
  });

  final Widget child;
  final double width;
  final double height;
  final Matrix4 matrix4;

  @override
  State<_TransformWidget> createState() => _TransformWidgetState();
}

class _TransformWidgetState extends State<_TransformWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fromRect(
          rect: Rect.fromLTWH(0, 0, widget.width, widget.height),
          child: widget.child,
        ),
        _TopLeft(
          matrix4: widget.matrix4,
        )
      ],
    );
  }
}

class _TopLeft extends StatelessWidget {
  const _TopLeft({required this.matrix4});

  final Matrix4 matrix4;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: const Rect.fromLTWH(-4, -4, 8, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: Colors.green)),
      ),
    );
  }
}
