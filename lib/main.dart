import 'package:flutter/material.dart';
import 'package:medibound_ui/components/inputs/Dropdown.dart';
import 'package:medibound_ui/components/inputs/ProgressFlow.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/medibound_ui.dart';
import './components/graph_types.dart';
import './components/widget_registry.dart';
import './components/inputs/ProfileDropdown.dart';
import './components/utils/Profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediBound UI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MediBound UI Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MBInfo? selectedItem;
  MBProfile? selectedProfile;
  MBTimeWindow selectedTimeWindow = MBTimeWindow.lastHour;
  
  final List<MBInfo> dropdownItems = [
    MBInfo(
      display: "Archimedic",
      description: "Manufacturer",
      code: "archimedic",
    ),
    MBInfo(
      display: "Venture Labs",
      description: "Research and Development",
      code: "venture_labs",
      color: Colors.blue,
      icon: "science",
    ),
    MBInfo(
      display: "Medibound",
      description: "Software Development",
      code: "medibound",
      color: Colors.teal,
      icon: "code",
    ),
    MBInfo(
      display: "BrickSimple",
      description: "Software Development",
      code: "bricksimple",
      color: Colors.red[900]!,
      icon: "architecture",
    ),
    MBInfo(
      display: "Penn Medicine",
      description: "Education",
      code: "penn_medicine",
      color: Colors.indigo[900]!,
      icon: "school",
    ),
  ];

  final List<MBProfile> profiles = [
    MBProfile(
      display: "John Smith",
      description: "Lead Developer",
      photoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgrPoFxnoMhPYStzoBvF2C51CrxYc2vo8-yg&s",
      uid: "user1",
    ),
    MBProfile(
      display: "Sarah Johnson",
      description: "Product Manager",
      photoUrl: "https://i.pravatar.cc/150?img=2",
      uid: "user2",
    ),
    MBProfile(
      display: "Michael Brown",
      description: "UX Designer",
      photoUrl: "https://i.pravatar.cc/150?img=3",
      uid: "user3",
    ),
    MBProfile(
      display: "Emily Davis",
      description: "Software Engineer",
      photoUrl: "https://i.pravatar.cc/150?img=4",
      uid: "user4",
    ),
  ];

  // Sample mock data for different medical measurements
  Map<String, dynamic> heartRateData = {
    "info": {
      "display": "Heart Rate",
      "code": "heart_rate",
      "description": "Beats per minute",
      "color": "",
      "icon": "favorite"
    },
    "unit": "bpm",
    "type": "number",
    "is_list": true,
    "data": List.generate(20, (index) {
      // Generate a realistic heart rate between 60-100 with some variation
      double value = 80 + (index % 5) * 3 - (index % 7) * 2;
      return {
        "number": value,
        "string": "Heart Rate",
        "timestamp": DateTime.now().subtract(Duration(minutes: index * 3)).toIso8601String()
      };
    }),
  };

  Map<String, dynamic> bloodOxygenData = {
    "info": {
      "display": "Blood Oxygen",
      "code": "spo2",
      "description": "Oxygen saturation",
      "color": "",
      "icon": "water_drop"
    },
    "unit": "%",
    "type": "number",
    "is_list": true,
    "data": List.generate(15, (index) {
      // Generate realistic SpO2 values (normally 95-100%)
      double value = 98 - (index % 8) * 0.5;
      return {
        "number": value,
        "string": "SpO2",
        "timestamp": DateTime.now().subtract(Duration(minutes: index * 4)).toIso8601String()
      };
    }),
  };

  Map<String, dynamic> temperatureData = {
    "info": {
      "display": "Body Temperature",
      "code": "temperature",
      "description": "Core body temperature",
      "color": "",
      "icon": "thermostat"
    },
    "unit": "°C",
    "type": "number",
    "is_list": true,
    "data": List.generate(10, (index) {
      // Generate realistic body temperature (normal is about 37°C)
      double value = 36.6 + (index % 5) * 0.2 - (index % 3) * 0.1;
      return {
        "number": value,
        "string": "Temperature",
        "timestamp": DateTime.now().subtract(Duration(hours: index)).toIso8601String()
      };
    }),
  };

  Map<String, dynamic> ecgData = {
    "info": {
      "display": "ECG",
      "code": "ecg",
      "description": "Electrocardiogram",
      "color": "",
      "icon": "monitor_heart"
    },
    "unit": "mV",
    "type": "number",
    "is_list": true,
    "data": List.generate(60, (index) {
      // Simulate ECG waveform with periodic peaks
      double baseValue = (index % 20 < 3) ? 2.0 : 0.5;
      double noise = (index % 7) * 0.1 - (index % 5) * 0.1;
      double value = baseValue + noise;
      return {
        "number": value,
        "string": "ECG",
        "timestamp": DateTime.now().subtract(Duration(seconds: index * 1)).toIso8601String()
      };
    }),
  };

  Map<String, dynamic> medicationComplianceData = {
    "info": {
      "display": "Medication Compliance",
      "code": "med_compliance",
      "description": "Adherence to medication schedule",
      "color": "",
      "icon": "medication"
    },
    "unit": "%",
    "type": "number",
    "is_list": true,
    "data": List.generate(10, (index) {
      // Generate realistic compliance data with some variation
      double value = 85 + (index % 3) * 5 - (index % 5) * 8;
      return {
        "number": value,
        "string": "Compliance",
        "timestamp": DateTime.now().subtract(Duration(days: index)).toIso8601String()
      };
    }),
  };
  
  // Mock data for the checklist progress indicator (order status)
  Map<String, dynamic> orderStatusData = {
    "info": {
      "display": "Order Status",
      "code": "order_status",
      "description": "Current status of the order",
      "color": "",
      "icon": "shopping_cart"
    },
    "unit": "m",
    "type": "number",
    "is_list": false,
    "data": [
      {
        "number": 2, // Representing 3rd stage (Shipped)
        "string": "Shipped",
        "timestamp": DateTime.now().toIso8601String()
      }
    ],
  };

  // List of steps for the ProgressFlow widget example
  final List<MBInfo> orderSteps = [
    MBInfo(
      display: "Ordered",
      description: "Order has been placed",
      code: "ordered",
      color: Colors.blue,
      icon: "shopping_cart",
    ),
    MBInfo(
      display: "Processing",
      description: "Order is being processed",
      code: "processing",
      color: Colors.orange,
      icon: "settings",
    ),
    MBInfo(
      display: "Shipped",
      description: "Order has been shipped",
      code: "shipped",
      color: Colors.green,
      icon: "local_shipping",
    ),
    MBInfo(
      display: "Delivered",
      description: "Order has been delivered",
      code: "delivered",
      color: Colors.teal,
      icon: "check_circle",
    ),
    
  ];
  
  final List<MBInfo> patientSteps = [
    MBInfo(
      display: "Registration",
      description: "Patient registration",
      code: "registration",
      color: Colors.blue,
      icon: "app_registration",
    ),
    MBInfo(
      display: "Screening",
      description: "Initial screening",
      code: "screening",
      color: Colors.orange,
      icon: "health_and_safety",
    ),
    MBInfo(
      display: "Diagnosis",
      description: "Medical diagnosis",
      code: "diagnosis",
      color: Colors.purple,
      icon: "monitor_heart",
    ),
    MBInfo(
      display: "Treatment",
      description: "Treatment plan",
      code: "treatment",
      color: Colors.green,
      icon: "medication",
    ),
    MBInfo(
      display: "Follow-up",
      description: "Follow-up care",
      code: "followup",
      color: Colors.teal,
      icon: "event_repeat",
    ),
  ];
  
  // Current step for each flow (can be controlled with UI if desired)
  int orderStep = 2; // Shipped
  int patientStep = 3; // Treatment

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Flow Widgets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Custom progress flow visualization for process tracking',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // Order Status Progress Flow
            const Text('Order Status Flow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ProgressFlow(
              steps: orderSteps,
              currentStep: orderStep,
              activeColor: FlutterFlowTheme.of(context).secondary,
              height: 100,
            ),
            const SizedBox(height: 24),
            
            // Patient Journey Progress Flow
            const Text('Patient Journey Flow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ProgressFlow(
              steps: patientSteps,
              currentStep: patientStep,
              activeColor: Colors.purple,
              height: 100,
            ),
            const SizedBox(height: 24),
            
            // Time window selector
            Row(
              children: [
                const Text('Time Window: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<MBTimeWindow>(
                  value: selectedTimeWindow,
                  items: MBTimeWindow.values.map((window) {
                    return DropdownMenuItem<MBTimeWindow>(
                      value: window,
                      child: Text(window.value.display),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTimeWindow = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Checklist Progress Gauge (Order Tracking)
            const Text('Checklist Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              child: getWidget('ChecklistProgress', Colors.teal, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: orderStatusData),
            ),
            const SizedBox(height: 24),

            // ECG Graph
            const Text('ECG Monitoring', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('ECG', Colors.green, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: ecgData),
            ),
            const SizedBox(height: 40),

            // Standard Graph Visualizations Section
            const Text(
              'Standard Graph Visualizations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The following visualizations showcase the versatility of the graph system',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Line Graph
            const Text('Line Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('Line', Colors.blue, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
            ),
            const SizedBox(height: 24),

            // Column Graph
            const Text('Column Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('Column', Colors.teal, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
            ),
            const SizedBox(height: 24),

            // Fast Line Graph
            const Text('Fast Line Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('FastLine', Colors.amber, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
            ),
            const SizedBox(height: 24),

            // Step Line Graph
            const Text('Step Line Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('StepLine', Colors.indigo, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
            ),
            const SizedBox(height: 24),

            // Scatter Graph
            const Text('Scatter Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('Scatter', Colors.deepOrange, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
            ),
            const SizedBox(height: 24),

            // Bubble Graph
            const Text('Bubble Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: getWidget('Bubble', Colors.pink, 'half', DateTime.now(),
                  timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
            ),
            const SizedBox(height: 24),

            // Quarter Size Visualizations Section
            const Text(
              'Quarter Size Visualizations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Radial Gauge
            const Text('Radial Gauges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('Radial', Colors.cyan, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('RadialHorizontal', Colors.deepPurple, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // More Quarter Gauges
            const Text('More Quarter Size Visualizations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('RadialIcon', Colors.brown, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('LinearGuage', Colors.lime, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Number visualizations
            const Text('Number Visualizations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('Number', Colors.green, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('NumberSplit', Colors.blueGrey, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Full Radial and Label Graphs
            const Text('Full Radial and Label Graphs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('FullRadial', Colors.teal, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    child: getWidget('LabelGraph', Colors.indigo, 'quarter', DateTime.now(),
                        timeWindowStr: selectedTimeWindow.name, variable: heartRateData),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            const Text('Standard Components', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Original Dropdown Components
            MBDropdown(
              items: dropdownItems,
              selectedItem: selectedItem,
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
              hintText: "Select an option",
            ),
            const SizedBox(height: 16),
            MbProfileDropdown(
              items: profiles,
              selectedItem: selectedProfile,
              onChanged: (profile) {
                setState(() {
                  selectedProfile = profile;
                });
              },
              hintText: "Select a team member",
              circle: true,
            ),
            if (selectedProfile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Selected: ${selectedProfile!.display} (${selectedProfile!.description})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
