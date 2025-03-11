import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';

class HalfSize extends StatelessWidget {
  final Widget child;
  final Widget tickerChild;
  final double height;

  final BuildContext context;

  const HalfSize({super.key, required this.context, required this.child, required this.tickerChild, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: Size(210*(height / 100), height),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: (height / 100),
        child: Container(
          height: 100, // Fixed total height
          width: 210,  // Fixed width
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end, // Align content at the top
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
                child: ClipRect(
                  child: child, // Ensure the graph does not overflow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
