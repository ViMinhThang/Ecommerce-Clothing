import 'package:flutter/material.dart';

class ColorUtils {
  static const Map<String, Color> _nameToColor = {
    'Black': Colors.black,
    'Blue': Color(0xFF1E88E5),
    'Green': Color(0xFF2E7D32),
    'Red': Color(0xFFD32F2F),
    'Pink': Color(0xFFF8BBD0),
    'Orange': Color(0xFFFFA000),
    'Beige': Color(0xFFF0E1C6),
    'Grey': Color(0xFFBDBDBD),
    'White': Colors.white,
    'Purple': Color(0xFF673AB7),
    'Yellow': Color(0xFFFFEB3B),
    'Brown': Color(0xFF795548),
    'Cyan': Color(0xFF00BCD4),
    'Teal': Color(0xFF009688),
    'Indigo': Color(0xFF3F51B5),
    'Lime': Color(0xFFCDDC39),
    'Amber': Color(0xFFFFC107),
    'Deep Orange': Color(0xFFFF5722),
    'Light Blue': Color(0xFF03A9F4),
    'Light Green': Color(0xFF8BC34A),
  };

  static Color getColorByName(String name) {
    for (var key in _nameToColor.keys) {
      if (key.toLowerCase() == name.toLowerCase()) {
        return _nameToColor[key]!;
      }
    }
    return Colors.grey;
  }
}
