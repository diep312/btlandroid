import 'package:flutter/material.dart';

class KDraggableBottomSheet extends StatefulWidget {
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool showHandle;
  static final ValueNotifier<bool> isSheetOpen = ValueNotifier<bool>(false);

  const KDraggableBottomSheet({
    Key? key,
    required this.child,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.3,
    this.maxChildSize = 0.95,
    this.showHandle = true,
  }) : super(key: key);

  @override
  State<KDraggableBottomSheet> createState() => _KDraggableBottomSheetState();
}

class _KDraggableBottomSheetState extends State<KDraggableBottomSheet> {
  late DraggableScrollableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _controller.addListener(_onDragUpdate);
  }

  void _onDragUpdate() {
    if (_controller.size > widget.minChildSize) {
      if (!KDraggableBottomSheet.isSheetOpen.value) {
        KDraggableBottomSheet.isSheetOpen.value = true;
      }
    } else {
      if (KDraggableBottomSheet.isSheetOpen.value) {
        KDraggableBottomSheet.isSheetOpen.value = false;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onDragUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEAF3FB), // light blue background
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showHandle)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}
