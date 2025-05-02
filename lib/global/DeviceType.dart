import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop
}

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  
  if (width < 600) {
    return DeviceType.mobile;
  } else if (width < 1200) {
    return DeviceType.tablet;
  } else {
    return DeviceType.desktop;
  }
} 