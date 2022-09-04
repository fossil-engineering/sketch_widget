part of 'draft_widget.dart';

class _TransformWidget extends StatelessWidget {
  const _TransformWidget({
    required this.id,
    required this.transformState,
    required this.focusPosition,
    required this.focusState,
    required this.hoverPosition,
    required this.hoverState,
    required this.transformingState,
    required this.position,
    required this.child,
  });

  final int id;
  final ValueNotifier<Matrix4> transformState;
  final ValueNotifier<Rect?> focusPosition;
  final ValueNotifier<int> focusState;
  final ValueNotifier<Rect?> hoverPosition;
  final ValueNotifier<int> hoverState;
  final ValueNotifier<bool> transformingState;
  final Rect position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: position,
      child: ValueListenableBuilder<Matrix4>(
        valueListenable: transformState,
        builder: (_, transform, child) {
          return id == focusState.value
              ? Transform(transform: transform, child: child)
              : child!;
        },
        child: GestureDetector(
          onTap: () {
            if (focusState.value != id) {
              focusState.value = id;
              focusPosition.value = position;
            }
          },
          child: MouseRegion(
            child: child,
            onEnter: (_) {
              if (hoverState.value != id &&
                  hoverState.value != focusState.value &&
                  !transformingState.value) {
                hoverState.value = id;
                hoverPosition.value = position;
              }
            },
            onExit: (_) {
              if (hoverState.value == id) {
                hoverState.value = noPosition;
                hoverPosition.value = null;
              }
            },
          ),
        ),
      ),
    );
  }
}
