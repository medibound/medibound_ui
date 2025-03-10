import 'package:flutter/material.dart';

class HalfSize extends StatelessWidget {
  final Widget child;
  final Widget tickerChild;

  final BuildContext context;

  const HalfSize({super.key, required this.context, required this.child, required this.tickerChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Fixed total height
      width: 210,  // Fixed width
      padding: const EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
    );
  }
}
