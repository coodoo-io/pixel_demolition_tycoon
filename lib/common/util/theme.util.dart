import 'package:flutter/material.dart';

extension ThemeExtension on ThemeData {
  bool get isLightMode => brightness == Brightness.light;
  bool get isDarkMode => brightness == Brightness.dark;
}
