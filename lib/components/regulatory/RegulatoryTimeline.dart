import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/global/DeviceType.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medibound_ui/models/regulatory/Tasks.dart';
import 'package:medibound_ui/components/inputs/ProgressFlow.dart';
import 'package:medibound_ui/components/inputs/Dropdown.dart';
import 'package:medibound_ui/medibound_ui.dart';
import 'dart:convert';

// Enums and Models
enum DeviceClass {
  classI,
  classII,
  classIII;
  
  String get displayName {
    switch (this) {
      case DeviceClass.classI:
        return 'Class I';
      case DeviceClass.classII:
        return 'Class II';
      case DeviceClass.classIII:
        return 'Class III';
      default:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case DeviceClass.classI:
        return 'Low-risk devices (e.g., bandages, hand-held surgical instruments)';
      case DeviceClass.classII:
        return 'Medium-risk devices (e.g., powered wheelchairs, infusion pumps)';
      case DeviceClass.classIII:
        return 'High-risk devices (e.g., implantable pacemakers, heart valves)';
      default:
        return '';
    }
  }
}

// Timeline data model to pass to the callback
class TimelineData {
  final DeviceClass deviceClass;
  final int currentStep;
  final Map<String, bool> checklistStatus;
  
  TimelineData({
    required this.deviceClass,
    required this.currentStep,
    required this.checklistStatus,
  });
  
  Map<String, dynamic> toJson() => {
    'deviceClass': deviceClass.index,
    'currentStep': currentStep,
    'checklistStatus': checklistStatus,
  };
  
  /// Creates a TimelineData instance from JSON data
  factory TimelineData.fromJson(Map<String, dynamic> json) {
    try {
      return TimelineData(
        deviceClass: DeviceClass.values[json['deviceClass'] as int],
        currentStep: json['currentStep'] as int,
        checklistStatus: Map<String, bool>.from(json['checklistStatus'] as Map),
      );
    } catch (e) {
      // Return a default TimelineData if parsing fails
      print('Error parsing TimelineData: $e');
      return TimelineData(
        deviceClass: DeviceClass.classII,
        currentStep: 1,
        checklistStatus: {},
      );
    }
  }
  
  /// Creates a TimelineData instance from a JSON string
  factory TimelineData.fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return TimelineData.fromJson(jsonData);
    } catch (e) {
      // Return a default TimelineData if parsing fails
      print('Error parsing TimelineData string: $e');
      return TimelineData(
        deviceClass: DeviceClass.classII,
        currentStep: 1,
        checklistStatus: {},
      );
    }
  }
}

typedef TimelineUpdateCallback = void Function(TimelineData data);

class RegulatoryTimeline extends StatefulWidget {
  final ValueChanged<List<RegulatoryTask>>? onTasksChanged;
  final Color? classIColor;
  final Color? classIIColor;
  final Color? classIIIColor;
  final ValueChanged<TimelineData>? onUpdate;
  final VoidCallback? onExport;
  final String? initialTimelineData; // JSON string representation of TimelineData
  
  const RegulatoryTimeline({
    Key? key,
    this.onTasksChanged,
    this.classIColor,
    this.classIIColor, 
    this.classIIIColor,
    this.onUpdate,
    this.onExport,
    this.initialTimelineData,
  }) : super(key: key);

  @override
  _RegulatoryTimelineState createState() => _RegulatoryTimelineState();
}

class _RegulatoryTimelineState extends State<RegulatoryTimeline> {
  late List<RegulatoryTask> _tasks;
  late DeviceClass _selectedDeviceClass;
  String? _expandedTaskId;
  bool _isLoading = true;
  int? _initialStep;
  
  // Map to group tasks by main category
  final Map<String, String> _categoryMap = {
    '1': 'Classification',
    '2': 'Testing',
    '3': 'Clinical',
    '4': 'Quality',
    '5': 'Submission',
    '6': 'Review',
    '7': 'Postmarket'
  };
  
  // Shortened one-word titles for main categories
  final Map<String, String> _shortTitles = {
    '1': 'Classify',
    '2': 'Test',
    '3': 'Trials',
    '4': 'QMS',
    '5': 'Submit',
    '6': 'Review',
    '7': 'Monitor'
  };
  
  // Icons for each category
  final Map<String, String> _categoryIcons = {
    '1': 'medical_services',
    '2': 'science',
    '3': 'people',
    '4': 'verified',
    '5': 'upload_file',
    '6': 'rate_review',
    '7': 'sensors'
  };
  
  @override
  void initState() {
    super.initState();
    
    // Try to parse initialTimelineData if provided
    if (widget.initialTimelineData != null && widget.initialTimelineData!.isNotEmpty) {
      try {
        // Parse the JSON string to TimelineData
        final TimelineData timelineData = TimelineData.fromJsonString(widget.initialTimelineData!);
        
        // Initialize from the TimelineData
        _selectedDeviceClass = timelineData.deviceClass;
        _initialStep = timelineData.currentStep;
        
        // Load tasks and apply saved checklistStatus
        _loadTasks(
          initialStep: timelineData.currentStep,
          initialChecklistStatus: timelineData.checklistStatus
        );
        return;
      } catch (e) {
        print('Error processing initialTimelineData: $e');
        // Continue with defaults if processing fails
      }
    }
    
    // Default initialization if initialTimelineData is not provided or processing failed
    _selectedDeviceClass = DeviceClass.classII; // Default to class II
    _loadTasks();
  }
  
  void _loadTasks({int? initialStep, Map<String, bool>? initialChecklistStatus}) async {
    setState(() {
      _tasks = getDefaultRegulatoryMilestones();
      _isLoading = false;
      
      // Apply initial checklist status if provided
      if (initialChecklistStatus != null) {
        for (var task in _tasks) {
          if (initialChecklistStatus.containsKey(task.id)) {
            task.isCompleted = initialChecklistStatus[task.id] ?? false;
          }
        }
      }
    });
  }

  void _updateTasksForDeviceClass() {
    // Only reset completion status when changing device class if no initial data was provided
    if (widget.initialTimelineData == null) {
      for (var task in _tasks) {
        task.isCompleted = false;
      }
    }
    
    // Notify about updated tasks
    _notifyUpdate();
  }
  
  void _notifyUpdate() {
    if (widget.onTasksChanged != null) {
      widget.onTasksChanged!(_tasks);
    }
    
    if (widget.onUpdate != null) {
      Map<String, bool> checklistStatus = {};
      for (var task in _tasks) {
        checklistStatus[task.id] = task.isCompleted;
      }
      
      widget.onUpdate!(TimelineData(
        deviceClass: _selectedDeviceClass,
        currentStep: _getMainCategoryStep(),
        checklistStatus: checklistStatus,
      ));
    }
  }
  
  // Get the current main category step for progress tracking
  int _getMainCategoryStep() {
    // Find the first incomplete main category
    for (int i = 1; i <= 7; i++) {
      String categoryId = i.toString();
      bool allCompleted = true;
      
      for (var task in _tasks) {
        if (task.id.startsWith('$categoryId.') && !task.isCompleted) {
          allCompleted = false;
          break;
        }
      }
      
      if (!allCompleted) {
        return i;
      }
    }
    
    // All categories completed
    return 8;
  }
  
  // Check if a task can be unchecked (only if it's the latest completed task)
  bool _canUncheckTask(RegulatoryTask task) {
    if (!task.isCompleted) return false;
    
    // Find the latest completed task
    RegulatoryTask? latestCompletedTask;
    for (var t in _tasks) {
      if (t.isCompleted && (latestCompletedTask == null || t.id.compareTo(latestCompletedTask.id) > 0)) {
        latestCompletedTask = t;
      }
    }
    
    // Can only uncheck the latest completed task
    return latestCompletedTask?.id == task.id;
  }

  // Get completion percentage for a specific category
  double _getCategoryCompletion(String categoryId) {
    int totalTasks = 0;
    int completedTasks = 0;
    
    for (var task in _tasks) {
      if (task.id.startsWith('$categoryId.')) {
        totalTasks++;
        if (task.isCompleted) {
          completedTasks++;
        }
      }
    }
    
    return totalTasks > 0 ? completedTasks / totalTasks : 0.0;
  }
  
  // Get tasks for a specific category
  List<RegulatoryTask> _getCategoryTasks(String categoryId) {
    return _tasks.where((task) => task.id.startsWith('$categoryId.')).toList();
  }

  // Convert only the main categories to MBInfo for ProgressFlow
  List<MBInfo> _mainCategoriesToMBInfo() {
    List<MBInfo> mainCategories = [];
    
    for (int i = 1; i <= 7; i++) {
      String categoryId = i.toString();
      // Check if all tasks in this category are completed
      bool categoryCompleted = _getCategoryCompletion(categoryId) == 1.0;
      
      mainCategories.add(MBInfo(
        display: _shortTitles[categoryId] ?? 'Step $categoryId',
        description: _categoryMap[categoryId] ?? 'Category $categoryId',
        code: categoryId,
        icon: categoryCompleted ? 'check' : _categoryIcons[categoryId] ?? 'circle_outlined',
      ));
    }
    
    return mainCategories;
  }

  // Convert device classes to MBInfo for dropdown
  List<MBInfo> _deviceClassesToMBInfo() {
    return DeviceClass.values.map((deviceClass) {
      String icon;
      switch (deviceClass) {
        case DeviceClass.classI:
          icon = 'healing'; // Simple medical supplies
          break;
        case DeviceClass.classII:
          icon = 'medical_services'; // Medium-risk medical devices
          break;
        case DeviceClass.classIII:
          icon = 'monitor_heart'; // Critical care devices
          break;
        default:
          icon = 'medical_services';
      }
      
      return MBInfo(
        display: deviceClass.displayName,
        description: deviceClass.description,
        code: deviceClass.index.toString(),
        color: _getDeviceClassColor(context, deviceClass),
        icon: icon,
      );
    }).toList();
  }
  
  // Check if device classification has been completed (task 1.1)
  bool _isDeviceClassLocked() {
    // Find the first task with id "1.1" (Device Classification)
    var classificationTask = _tasks.firstWhere(
      (task) => task.id == '1.1',
      orElse: () => RegulatoryTask(id: '', title: '', description: ''),
    );
    
    // Return true if the task exists and is completed
    return classificationTask.id.isNotEmpty && classificationTask.isCompleted;
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    DeviceType deviceType = getDeviceType(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and ProgressFlow only
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                /*Text(
                  "FDA Regulatory Timeline",
                  style: FlutterFlowTheme.of(context).headlineSmall,
                ),
                const SizedBox(height: 16),*/
                
                // ProgressFlow for 7 main categories
                ProgressFlow(
                  steps: _mainCategoriesToMBInfo(),
                  currentStep: _getMainCategoryStep(),
                  activeColor: _getDeviceClassColor(context),
                  height: 100,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Main category cards with subtasks
            ...List.generate(7, (index) {
              String categoryId = (index + 1).toString();
              String categoryTitle = _categoryMap[categoryId] ?? 'Category $categoryId';
              String categoryIcon = _categoryIcons[categoryId] ?? 'circle_outlined';
              List<RegulatoryTask> categoryTasks = _getCategoryTasks(categoryId);
              double completion = _getCategoryCompletion(categoryId);
              bool isFirstCategory = index == 0;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 24),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: completion == 1.0 
                        ? FlutterFlowTheme.of(context).secondary.withOpacity(0.5) 
                        : Colors.transparent ,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category header
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: completion == 1.0 
                                  ? FlutterFlowTheme.of(context).secondary.withOpacity(0.1) 
                                  : _getDeviceClassColor(context).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: completion == 1.0 
                                    ? FlutterFlowTheme.of(context).secondary 
                                    : _getDeviceClassColor(context),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                completion == 1.0 
                                    ? Icons.check 
                                    : iconsMap[categoryIcon] ?? Icons.circle_outlined,
                                color: completion == 1.0 
                                    ? FlutterFlowTheme.of(context).secondary 
                                    : _getDeviceClassColor(context),
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Step $categoryId: $categoryTitle",
                                  style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: completion,
                                          backgroundColor: FlutterFlowTheme.of(context).alternate,
                                          color: completion == 1.0 
                                              ? FlutterFlowTheme.of(context).secondary 
                                              : _getDeviceClassColor(context),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${(completion * 100).toInt()}%",
                                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                        color: completion == 1.0 
                                            ? FlutterFlowTheme.of(context).secondary 
                                            : _getDeviceClassColor(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Add device class dropdown to first card only
                      if (isFirstCategory) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Select Device Classification:",
                                    style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (_isDeviceClassLocked()) ...[
                                    const SizedBox(width: 8),
                                    Tooltip(
                                      message: "Device class is locked after classification is completed",
                                      child: Icon(
                                        Icons.lock_outline,
                                        size: 16,
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                children: [
                                  MBDropdown(
                                    items: _deviceClassesToMBInfo(),
                                    selectedItem: _deviceClassesToMBInfo()[_selectedDeviceClass.index],
                                    onChanged: _isDeviceClassLocked() 
                                        ? (_) {} // No-op function instead of null 
                                        : (selectedItem) {
                                            if (selectedItem != null) {
                                              setState(() {
                                                _selectedDeviceClass = DeviceClass.values[int.parse(selectedItem.code)];
                                                _updateTasksForDeviceClass();
                                              });
                                            }
                                          },
                                    hintText: "Select device class",
                                    isEnabled: !_isDeviceClassLocked(),
                                  ),
                                  if (_isDeviceClassLocked()) 
                                    Positioned.fill(
                                      child: Tooltip(
                                        message: "Device class selection is locked after classification is completed",
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '• Complete tasks in order - some tasks require previous ones to be completed\n'
                                '• Locked tasks (🔒) will become available after completing required prerequisites\n'
                                '• Each task includes FDA resources to help you complete the requirement',
                                style: FlutterFlowTheme.of(context).bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      
                      // Subtasks
                      ...categoryTasks.map((task) => _buildSubtaskItem(task)).toList(),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Get color based on device class
  Color _getDeviceClassColor(BuildContext context, [DeviceClass? deviceClass]) {
    DeviceClass classToUse = deviceClass ?? _selectedDeviceClass;
    
    switch (classToUse) {
      case DeviceClass.classI:
        return widget.classIColor ?? FlutterFlowTheme.of(context).secondary;
      case DeviceClass.classII:
        return widget.classIIColor ?? getMBColorByName('Midnight');
      case DeviceClass.classIII:
        return widget.classIIIColor ?? getMBColorByName('Flare');
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }

  // Build a subtask item
  Widget _buildSubtaskItem(RegulatoryTask task) {
    bool canAccess = task.canAccess(_tasks);
    bool canUncheck = _canUncheckTask(task);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: canAccess ? FlutterFlowTheme.of(context).secondaryBackground : FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: canAccess 
              ? (task.isCompleted ? FlutterFlowTheme.of(context).secondary.withOpacity(0.3) : FlutterFlowTheme.of(context).alternate) 
              : FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: task.isCompleted 
                      ? FlutterFlowTheme.of(context).secondary.withOpacity(0.1) 
                      : (canAccess ? FlutterFlowTheme.of(context).secondaryBackground : FlutterFlowTheme.of(context).alternate),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isCompleted 
                        ? FlutterFlowTheme.of(context).secondary 
                        : (canAccess ? _getDeviceClassColor(context) : FlutterFlowTheme.of(context).alternate),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Icon(
                    task.isCompleted 
                        ? Icons.check 
                        : (canAccess ? null : Icons.lock_outline),
                    color: task.isCompleted 
                        ? FlutterFlowTheme.of(context).secondary 
                        : (canAccess ? _getDeviceClassColor(context) : FlutterFlowTheme.of(context).alternate),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: canAccess ? FlutterFlowTheme.of(context).primaryText : FlutterFlowTheme.of(context).alternate,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (task.id == '1.1' && task.isCompleted) ...[
                Tooltip(
                  message: "This locks the device class selection",
                  child: Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: getMBColorByName("Amber"),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ],
          ),
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                color: canAccess ? FlutterFlowTheme.of(context).primaryText : FlutterFlowTheme.of(context).alternate,
              ),
            ),
            
            if (canAccess) ...[
              const SizedBox(height: 16),
              // Checkbox
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: task.isCompleted ? FlutterFlowTheme.of(context).secondary.withOpacity(0.1) : _getDeviceClassColor(context).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      activeColor: FlutterFlowTheme.of(context).secondary,
                      checkColor: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? value) {
                        if (value == false && !canUncheck) {
                          // Show a tooltip or message that you can only uncheck the latest task
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You can only uncheck tasks in reverse order'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        
                        setState(() {
                          task.isCompleted = value ?? false;
                          _notifyUpdate();
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                          color: task.isCompleted ? FlutterFlowTheme.of(context).secondary : _getDeviceClassColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // FDA Resources
              if (task.resources.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.library_books, size: 16, color: _getDeviceClassColor(context)),
                    const SizedBox(width: 8),
                    Text(
                      'FDA Resources:',
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getDeviceClassColor(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...task.resources.map((resource) {
                  final uri = Uri.parse(resource);
                  final filename = uri.pathSegments.isNotEmpty 
                      ? uri.pathSegments.last 
                      : uri.host;
                  final title = filename
                      .replaceAll('-', ' ')
                      .replaceAll('/', ' ')
                      .replaceAll('.html', '')
                      .replaceAll('.htm', '')
                      .split(' ')
                      .map((word) => word.isNotEmpty 
                          ? '${word[0].toUpperCase()}${word.substring(1)}' 
                          : '')
                      .join(' ');
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.link, size: 14, color: _getDeviceClassColor(context).withOpacity(0.7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => _launchURL(resource),
                            child: Text(
                              title,
                              style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                color: _getDeviceClassColor(context),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ] else ...[
              // Show locked message
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Complete ${task.dependsOn.map((id) => 'Task $id').join(', ')} to unlock',
                        style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
} 