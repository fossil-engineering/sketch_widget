part of 'draft_widget.dart';

class _TransformWidget extends StatelessWidget {
  const _TransformWidget({
    required this.onTap,
    required this.onEnter,
    required this.onExit,
    required this.child,
  });

  final void Function() onTap;
  final void Function() onEnter;
  final void Function() onExit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        child: child,
        onEnter: (_) => onEnter(),
        onExit: (_) => onExit(),
      ),
    );
  }
}
