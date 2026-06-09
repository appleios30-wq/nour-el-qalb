import 'package:flutter/material.dart';

enum DhikrCategory { general, morning, evening, sleep }

extension DhikrCategoryExtension on DhikrCategory {
  String get label {
    switch (this) {
      case DhikrCategory.general:
        return 'أذكار مطلقة';
      case DhikrCategory.morning:
        return 'أذكار الصباح';
      case DhikrCategory.evening:
        return 'أذكار المساء';
      case DhikrCategory.sleep:
        return 'أذكار النوم';
    }
  }

  String get name {
    switch (this) {
      case DhikrCategory.general:
        return 'general';
      case DhikrCategory.morning:
        return 'morning';
      case DhikrCategory.evening:
        return 'evening';
      case DhikrCategory.sleep:
        return 'sleep';
    }
  }

  static DhikrCategory fromString(String value) {
    switch (value) {
      case 'morning':
        return DhikrCategory.morning;
      case 'evening':
        return DhikrCategory.evening;
      case 'sleep':
        return DhikrCategory.sleep;
      default:
        return DhikrCategory.general;
    }
  }
}

class Dhikr {
  final String id;
  final String text;
  final String arabicName;
  Color neonColor;
  final int targetCount;
  final String virtue;
  int currentCount;
  final bool isCustom;
  String fontFamily;
  final DhikrCategory category;

  Dhikr({
    required this.id,
    required this.text,
    required this.arabicName,
    required this.neonColor,
    required this.targetCount,
    required this.virtue,
    this.currentCount = 0,
    this.isCustom = false,
    this.fontFamily = 'Cairo',
    this.category = DhikrCategory.general,
  });

  bool get isCompleted => currentCount >= targetCount;

  void reset() {
    currentCount = 0;
  }

  void increment() {
    if (!isCompleted) {
      currentCount++;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'arabicName': arabicName,
    'neonColor': neonColor.value,
    'targetCount': targetCount,
    'virtue': virtue,
    'currentCount': currentCount,
    'isCustom': isCustom,
    'fontFamily': fontFamily,
    'category': category.name,
  };

  factory Dhikr.fromJson(Map<String, dynamic> json) => Dhikr(
    id: json['id'],
    text: json['text'],
    arabicName: json['arabicName'],
    neonColor: Color(json['neonColor']),
    targetCount: json['targetCount'],
    virtue: json['virtue'],
    currentCount: json['currentCount'] ?? 0,
    isCustom: json['isCustom'] ?? false,
    fontFamily: json['fontFamily'] ?? 'Cairo',
    category: DhikrCategoryExtension.fromString(
      json['category'] ?? 'general',
    ),
  );
}
