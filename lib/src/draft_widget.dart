import 'package:flutter/material.dart';

part 'transform_widget.dart';

part 'hover_widget.dart';

/// DraftWidget to draft widgets
class DraftWidget extends StatelessWidget {
  /// DraftWidget Constructor
  DraftWidget({required this.sketch, super.key});

  /// Widgets will be drafted.
  final Map<int, Map<String, dynamic>> sketch;

  final _focus = ValueNotifier<int>(-1);
  final _hover = ValueNotifier<int>(-1);
  final _controller = TransformationController();
  final _scale = ValueNotifier<double>(1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focus.value = -1,
      child: InteractiveViewer(
        transformationController: _controller,
        onInteractionUpdate: (_) {
          _scale.value = _controller.value.getMaxScaleOnAxis();
        },
        child: Stack(
          children: [
            ...sketch.entries.map(
              (e) => Positioned.fromRect(
                rect: e.value['position'] as Rect,
                child: _TransformWidget(
                  onTap: () => _focus.value = e.key,
                  onEnter: () {
                    if (_hover.value != e.key) _hover.value = e.key;
                  },
                  onExit: () {
                    if (_hover.value == e.key) _hover.value = -1;
                  },
                  child: e.value['widget'] as Widget,
                ),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _hover,
              builder: (_, hover, child) {
                if (hover == -1) return child!;
                return ValueListenableBuilder<double>(
                  valueListenable: _scale,
                  builder: (_, scale, ___) => _HoverWidget(
                    position: sketch[hover]!['position'] as Rect,
                    scale: scale,
                  ),
                );
              },
              child: Positioned.fromRect(
                rect: Rect.zero,
                child: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
