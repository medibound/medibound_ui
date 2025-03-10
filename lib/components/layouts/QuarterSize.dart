import 'package:flutter/material.dart';
import '../../components/theme.dart';


class QuarterSize extends StatelessWidget {
  final Widget child;
  final BuildContext context;

  const QuarterSize({super.key, required this.context, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
