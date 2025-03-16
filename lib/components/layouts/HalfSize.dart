import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';

class HalfSize extends StatelessWidget {
  final Widget child;
  final double height;
  final BuildContext context;

  const HalfSize({
    super.key,
    required this.context,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect( // ✅ Crops anything outside the container
      child: SizedBox( // ✅ Allows content to be larger, but cropped by ClipRect
        width: 207.5 * (height / 100.0),
        height: height,
        child: FittedBox(
          child: Container(
            height: 100.0, // Fixed total height
            width: 207.5,  // Fixed width
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

