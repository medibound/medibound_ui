import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';

class HalfSize extends StatelessWidget {
  final Widget child;
  final Widget tickerChild;
  final double height;
  final BuildContext context;

  const HalfSize({
    super.key,
    required this.context,
    required this.child,
    required this.tickerChild,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end, // Align content at the bottom
              children: [
                Expanded(
                  flex: 1, // Takes 1/3 of the space
                  child: Align(
                    alignment: Alignment.center,
                    child: tickerChild,
                  ),
                ),
                Expanded(
                  flex: 2, // Takes 2/3 of the space
                  child: ClipRect( // ✅ Ensures no overflow outside the defined space
                    child: child, // The graph or content
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
