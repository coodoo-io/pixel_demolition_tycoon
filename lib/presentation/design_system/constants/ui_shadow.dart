import 'package:flutter/material.dart';

/// Follows the design atom for Elevation (-1,0.5,1,2,3,4,5)
class UiShadow {
  static final elevationOneHalf = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      spreadRadius: 1,
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      spreadRadius: 0,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
}
