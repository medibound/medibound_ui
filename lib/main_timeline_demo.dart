import 'package:flutter/material.dart';
import 'package:medibound_ui/components/regulatory/RegulatoryTimeline.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/medibound_ui.dart';
import 'dart:convert';

void main() {
  runApp(const MediboundTimelineApp());
}

class MediboundTimelineApp extends StatelessWidget {
  const MediboundTimelineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medibound Regulatory Timeline',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: const TimelineDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimelineDashboard extends StatefulWidget {
  const TimelineDashboard({Key? key}) : super(key: key);

  @override
  _TimelineDashboardState createState() => _TimelineDashboardState();
}

class _TimelineDashboardState extends State<TimelineDashboard> {
  TimelineData? _currentData;
  bool _isSyncing = false;
  String? _savedTimelineDataJson;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: RegulatoryTimeline(
                initialTimelineData: '{"deviceClass":0,"currentStep":1,"checklistStatus":{"1.1":true,"1.2":false,"1.3":false,"2.1":false,"2.2":false,"2.3":false,"3.1":false,"3.2":false,"3.3":false,"4.1":false,"4.2":false,"4.3":false,"5.1":false,"5.2":false,"5.3":false,"6.1":false,"6.2":false,"6.3":false,"7.1":false,"7.2":false,"7.3":false}}',
                classIColor: FlutterFlowTheme.of(context).secondary,
                classIIColor: getMBColorByName('Midnight'),
                classIIIColor: getMBColorByName('Flare'),
                onUpdate: (data) {
                  // Store the latest data
                  setState(() {
                    _currentData = data;
                    // Save the data as JSON string
                    _savedTimelineDataJson = json.encode(data.toJson());
                  });
                  
                  // Simulate cloud storage update
                  _syncToCloud(data);
                },
                onExport: () {
                  // Implementation for exporting the timeline
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Timeline exported successfully')),
                  );
                },
              ),
            ),
            if (_savedTimelineDataJson != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Clear saved data to demonstrate restarting with defaults
                          _savedTimelineDataJson = null;
                          _currentData = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Timeline data cleared - restarting with defaults')),
                        );
                      },
                      child: const Text('Reset Timeline'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Simulate cloud synchronization
  Future<void> _syncToCloud(TimelineData data) async {
    // Show syncing indicator
    setState(() {
      _isSyncing = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // You would implement actual cloud storage here
    // For example:
    // await FirebaseFirestore.instance
    //   .collection('regulatory_timelines')
    //   .doc('user_123')
    //   .set(data.toJson());
    
    // For demonstration, we'll just print the data
    print('Syncing to cloud: ${data.toJson()}');
    
    // Hide syncing indicator
    setState(() {
      _isSyncing = false;
    });
    
    // Optionally show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress synced to cloud'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
