import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/Colors.dart';

class MBVariablePreset {
  final String display;
  final String description;
  final String code;
  final Color color;
  final String icon;
  final dynamic options;
  final String type;
  final String unit;

  MBVariablePreset({
    required this.display,
    required this.description,
    required this.code,
    required this.color,
    required this.icon,
    this.options,
    required this.type,
    required this.unit
  });
}

List<MBVariablePreset> mBVariablePresets = [
  MBVariablePreset(
    display: "Active Energy Burned",
    description: "The amount of active energy burned.",
    code: "activeEnergyBurned",
    color: getMBColorByName("Crayola"),
    icon: "local_fire_department",
    type: "number",
    unit: "cal",
  ),
  MBVariablePreset(
    display: "Basal Energy Burned",
    description: "The amount of basal energy burned.",
    code: "basalEnergyBurned",
    color: getMBColorByName("Flare"),
    icon: "battery_full",
    type: "number",
    unit: "cal",
  ),
  MBVariablePreset(
    display: "Blood Glucose",
    description: "The user's blood glucose level.",
    code: "bloodGlucose",
    color: getMBColorByName("Munsell"),
    icon: "bloodtype",
    options: {
      "range": {
        "lower": 70.0,
        "upper": 200.0
      }
    },
    type: "number",
    unit: "mg/dL",
  ),
  MBVariablePreset(
    display: "Blood Oxygen",
    description: "The user's blood oxygen level.",
    code: "bloodOxygen",
    color: getMBColorByName("Health"),
    icon: "air",
    options: {
      "range": {
        "lower": 0.0,
        "upper": 100.0
      }
    },
    type: "number",
    unit: "%",
  ),
  MBVariablePreset(
    display: "Blood Pressure Diastolic",
    description: "The user's diastolic blood pressure.",
    code: "bloodPressureDiastolic",
    color: getMBColorByName("Midnight"),
    icon: "monitor_heart",
    options: {
      "range": {
        "lower": 60.0,
        "upper": 90.0
      }
    },
    type: "number",
    unit: "mm[Hg]",
  ),
  MBVariablePreset(
    display: "Blood Pressure Systolic",
    description: "The user's systolic blood pressure.",
    code: "bloodPressureSystolic",
    color: getMBColorByName("Crystal"),
    icon: "monitor_heart",
    options: {
      "range": {
        "lower": 90.0,
        "upper": 140.0
      }
    },
    type: "number",
    unit: "mm[Hg]",
  ),
  MBVariablePreset(
    display: "Body Fat Percentage",
    description: "The user's body fat percentage.",
    code: "bodyFatPercentage",
    color: getMBColorByName("Slate"),
    icon: "fitness_center",
    options: {
      "range": {
        "lower": 0.0,
        "upper": 100.0
      }
    },
    type: "number",
    unit: "%",
  ),
  MBVariablePreset(
    display: "Body Mass Index",
    description: "The user's body mass index (BMI).",
    code: "bodyMassIndex",
    color: getMBColorByName("Midnight"),
    icon: "scale",
    options: {
      "range": {
        "lower": 18.5,
        "upper": 30.0
      }
    },
    type: "number",
    unit: "{none}",
  ),
  MBVariablePreset(
    display: "Body Temperature",
    description: "The user's body temperature.",
    code: "bodyTemperature",
    color: getMBColorByName("Amber"),
    icon: "thermostat",
    options: {
      "range": {
        "lower": 30.0,
        "upper": 50.0
      }
    },
    type: "number",
    unit: "Cel",
  ),
  MBVariablePreset(
    display: "Heart Rate",
    description: "The user's heart rate.",
    code: "heartRate",
    color: getMBColorByName("Crayola"),
    icon: "favorite",
    options: {
      "range": {
        "lower": 40.0,
        "upper": 180.0
      }
    },
    type: "number",
    unit: "/min",
  ),
  MBVariablePreset(
    display: "Respiratory Rate",
    description: "The user's respiratory rate.",
    code: "respiratoryRate",
    color: getMBColorByName("Munsell"),
    icon: "lungs",
    options: {
      "range": {
        "lower": 10.0,
        "upper": 30.0
      }
    },
    type: "number",
    unit: "/min",
  ),
  MBVariablePreset(
    display: "Resting Heart Rate",
    description: "The user's resting heart rate.",
    code: "restingHeartRate",
    color: getMBColorByName("Midnight"),
    icon: "self_improvement",
    options: {
      "range": {
        "lower": 40.0,
        "upper": 100.0
      }
    },
    type: "number",
    unit: "/min",
  ),
  MBVariablePreset(
    display: "Steps",
    description: "The number of steps taken.",
    code: "steps",
    color: getMBColorByName("Slate"),
    icon: "directions_walk",
    type: "number",
    unit: "{count}",
  ),
  MBVariablePreset(
    display: "Water Intake",
    description: "The amount of water consumed.",
    code: "water",
    color: getMBColorByName("Munsell"),
    icon: "water_drop",
    type: "number",
    unit: "L",
  ),
  MBVariablePreset(
    display: "Weight",
    description: "The user's weight.",
    code: "weight",
    color: getMBColorByName("Amber"),
    icon: "scale",
    type: "number",
    unit: "kg",
  ),
  MBVariablePreset(
    display: "Workout",
    description: "The user's workout data.",
    code: "workout",
    color: getMBColorByName("Crystal"),
    icon: "fitness_center",
    type: "number",
    unit: "{none}",
  ),
  MBVariablePreset(
    display: "Custom Profile",
    description: "The user's custom data with more options.",
    code: "customProfile",
    color: getMBColorByName("Slate"),
    icon: "tune",
    type: "custom",
    unit: "{none}",
  ),
];
