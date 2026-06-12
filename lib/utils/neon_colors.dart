import 'package:flutter/material.dart';

class NeonColors {
  static const Color blue = Color(0xFF00BFFF);
  static const Color green = Color(0xFF00FF7F);
  static const Color gold = Color(0xFFFFD700);
  static const Color purple = Color(0xFF9400D3);
  static const Color pink = Color(0xFFFF69B4);
  static const Color orange = Color(0xFFFF8C00);
  static const Color cyan = Color(0xFF00CED1);
  static const Color silver = Color(0xFFC0C0C0);

  static const Color darkBackground = Color(0xFF0a0a1a);
  static const Color darkCard = Color(0xFF1a1a2e);

  static const Color rayOrange = Color(0xFFFFB347);
  static const Color rayWhiteBlue = Color(0xFF87CEEB);

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
        Shadow(color: color.withOpacity(0.8), blurRadius: 10),
        Shadow(color: color.withOpacity(0.4), blurRadius: 20),
      ],
    );
  }
}

class BackgroundPreset {
  final String id;
  final String name;
  final List<Color> gradientColors;

  const BackgroundPreset({
    required this.id,
    required this.name,
    required this.gradientColors,
  });
}

final Map<String, List<BackgroundPreset>> backgroundPresets = {
  'morning': [
    BackgroundPreset(
      id: 'morning_1',
      name: 'فجر مضيء',
      gradientColors: [const Color(0xFF1a0a2a), const Color(0xFF0a0a1a)],
    ),
    BackgroundPreset(
      id: 'morning_2',
      name: 'شروق ذهبي',
      gradientColors: [const Color(0xFF2a1a0a), const Color(0xFF0a0a1a)],
    ),
    BackgroundPreset(
      id: 'morning_3',
      name: 'صباح أزرق',
      gradientColors: [const Color(0xFF0a1a2a), const Color(0xFF0a0a2a)],
    ),
  ],
  'evening': [
    BackgroundPreset(
      id: 'evening_1',
      name: 'غروب بنفسجي',
      gradientColors: [const Color(0xFF2a0a1a), const Color(0xFF0a0a1a)],
    ),
    BackgroundPreset(
      id: 'evening_2',
      name: 'مساء أحمر',
      gradientColors: [const Color(0xFF2a0a0a), const Color(0xFF1a0a0a)],
    ),
    BackgroundPreset(
      id: 'evening_3',
      name: '-twilight أزرق',
      gradientColors: [const Color(0xFF1a0a2a), const Color(0xFF0a0a2a)],
    ),
  ],
  'sleep': [
    BackgroundPreset(
      id: 'sleep_1',
      name: 'ليل مظلم',
      gradientColors: [const Color(0xFF0a0a2a), const Color(0xFF0a0a1a)],
    ),
    BackgroundPreset(
      id: 'sleep_2',
      name: 'نجوم لامعة',
      gradientColors: [const Color(0xFF0a1a3a), const Color(0xFF0a0a2a)],
    ),
    BackgroundPreset(
      id: 'sleep_3',
      name: 'قمر فضي',
      gradientColors: [const Color(0xFF1a1a2a), const Color(0xFF0a0a1a)],
    ),
  ],
  'general': [
    BackgroundPreset(
      id: 'general_1',
      name: 'داكن كلاسيكي',
      gradientColors: [const Color(0xFF1a1a2e), const Color(0xFF0a0a1a)],
    ),
    BackgroundPreset(
      id: 'general_2',
      name: 'نيون أزرق',
      gradientColors: [const Color(0xFF0a0a2a), const Color(0xFF0a0a3a)],
    ),
    BackgroundPreset(
      id: 'general_3',
      name: 'فضي أنيق',
      gradientColors: [const Color(0xFF1a1a1a), const Color(0xFF0a0a1a)],
    ),
  ],
};
