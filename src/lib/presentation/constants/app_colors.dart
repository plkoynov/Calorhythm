import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF1976D2);
  static const primaryVariant = Color(0xFF004BA0);
  static const secondary = Color(0xFFFF7043);
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const error = Color(0xFFD32F2F);
  static const onPrimary = Colors.white;
  static const onSurface = Color(0xFF212121);
  static const onBackground = Color(0xFF424242);

  // Exercise tile palette
  static const tileColors = [
    Color(0xFFEF5350), // red
    Color(0xFFAB47BC), // purple
    Color(0xFF42A5F5), // blue
    Color(0xFF26A69A), // teal
    Color(0xFF66BB6A), // green
    Color(0xFFFFA726), // orange
    Color(0xFF8D6E63), // brown
    Color(0xFF78909C), // blue-grey
  ];
}
