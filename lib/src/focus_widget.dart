part of 'draft_widget.dart';

class _FocusWidget extends StatefulWidget {
  const _FocusWidget({
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
  State<_FocusWidget> createState() => _FocusWidgetState();
}

class _FocusWidgetState extends State<_FocusWidget> {
  var _focus = false;
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        onTap: () => setState(() => _focus ^= true),
        child: _focus
            ? _TransformWidget(
                width: widget.width,
                height: widget.height,
                matrix4: widget.matrix4,
                child: widget.child,
              )
            : _hover
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                    ),
                    position: DecorationPosition.foreground,
                    child: widget.child,
                  )
                : widget.child,
      ),
      onEnter: (e) => setState(() => _hover = true),
      onExit: (e) => setState(() => _hover = false),
    );
  }
}
