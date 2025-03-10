import 'package:flutter/material.dart';
import '../../components/graph_types.dart';

class LastTicker extends StatelessWidget {
  final List<ChartData> data;
  final BuildContext context;

  const LastTicker({super.key, required this.context, required this.data});

  @override
  Widget build(BuildContext context) {
    // Ensure there is data
    if (data.isEmpty) {
      return Column(
        children: [
          Text("No Data", style: TextStyle(fontSize: 12, color: Colors.black)),
        ],
      );
    }

    // Get the most recent data point
    final lastData = data.last;

    return Column(
      children: [
        Text(
          "Latest: ${lastData.y}", // Display the latest value
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
