import 'package:flutter/material.dart';

class MBColor {
  final String display;
  final String description;
  final Color color;
  final String code;

  MBColor({
    required this.display,
    required this.description,
    required this.color,
    String? code, // Allow nullable input
  }) : code = code ?? color.toString(); // Convert color to hex
}

List<MBColor> mBColors = [
  MBColor(
    display: "Crayola",
    description: "Bright Pink",
    color: Color(0xFFEF476F),
    code: "EF476F",
  ),
  MBColor(
    display: "Flare",
    description: "Solar Orange",
    color: Color(0xFFFF7F50),
    code: "FF7F50",
  ),
  MBColor(
    display: "Amber",
    description: "Sunset Yellow",
    color: Color(0xFFFFC43D),
    code: "FFC43D",
  ),
  MBColor(
    display: "Health",
    description: "Emerald Green",
    color: Color(0xFF00D6A1),
    code: "00D6A1",
  ),
  MBColor(
    display: "Munsell",
    description: "Ocean Teal",
    color: Color(0xFF34C1D1),
    code: "1B9AAA",
  ),
  MBColor(
    display: "Midnight",
    description: "Deep Blue",
    color: Color(0xFF5278FE),
    code: "1B4872",
  ),
  MBColor(
    display: "Crystal",
    description: "Soothing Purple",
    color: Color(0xFFEC3FD2),
    code: "C54B8C",
  ),
  MBColor(
    display: "Slate",
    description: "Determined Gray",
    color: Color(0xFF8BA7C3),
    code: "6D8196",
  ),
];

Color getMBColorByName(String name) {
  return mBColors.firstWhere(
    (c) => c.display.toLowerCase() == name.toLowerCase(),
    orElse: () => MBColor(
      display: "Default",
      description: "Default color",
      color: Colors.grey,
      code: "000000",
    ),
  ).color;
}