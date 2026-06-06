import 'package:flutter/material.dart';

class NeonColors {
  // ألوان النيون الأساسية
  static const Color blue = Color(0xFF00BFFF);
  static const Color green = Color(0xFF00FF7F);
  static const Color gold = Color(0xFFFFD700);
  static const Color purple = Color(0xFF9400D3);
  static const Color pink = Color(0xFFFF69B4);
  static const Color orange = Color(0xFFFF8C00);
  static const Color cyan = Color(0xFF00CED1);
  static const Color silver = Color(0xFFC0C0C0);
  
  // ألوان الخلفية
  static const Color darkBackground = Color(0xFF0a0a1a);
  static const Color darkCard = Color(0xFF1a1a2e);
  
  // ألوان الأشعة
  static const Color rayOrange = Color(0xFFFFB347);
  static const Color rayWhiteBlue = Color(0xFF87CEEB);
  
  // ألوان الوقت
  static const Color morningGradientStart = Color(0xFF1a0a2a);
  static const Color morningGradientEnd = Color(0xFF0a0a1a);
  static const Color eveningGradientStart = Color(0xFF2a0a1a);
  static const Color eveningGradientEnd = Color(0xFF0a0a1a);
  
  // تأثيرات النيون
  static List<BoxShadow> getNeonGlow(Color color, {double intensity = 1.0}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.6 * intensity),
        blurRadius: 20 * intensity,
        spreadRadius: 5 * intensity,
      ),
      BoxShadow(
        color: color.withOpacity(0.3 * intensity),
        blurRadius: 40 * intensity,
        spreadRadius: 10 * intensity,
      ),
    ];
  }
  
  static TextStyle getNeonTextStyle(Color color, {double fontSize = 24}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      shadows: [
        Shadow(
          color: color.withOpacity(0.8),
          blurRadius: 10,
        ),
        Shadow(
          color: color.withOpacity(0.4),
          blurRadius: 20,
        ),
      ],
    );
  }
}
