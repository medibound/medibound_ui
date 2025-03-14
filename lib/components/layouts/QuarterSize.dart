import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
//import '../../components/theme.dart';


class QuarterSize extends StatelessWidget {
  final Widget child;
  final BuildContext context;
  final double height;

  const QuarterSize({super.key, required this.context, required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRect( // ✅ Crops anything outside the container
      child: SizedBox( // ✅ Allows content to be larger, but cropped by ClipRect
        width: height,
        height: height,
        child: FittedBox(
          child: Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ))),
    );
  }
}
