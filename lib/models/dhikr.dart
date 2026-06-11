import 'package:flutter/material.dart';

List<String> get builtInCategoryIds => ['general', 'morning', 'evening', 'sleep'];

String categoryLabel(String id) {
  switch (id) {
    case 'general': return 'أذكار مطلقة';
    case 'morning': return 'أذكار الصباح';
    case 'evening': return 'أذكار المساء';
    case 'sleep': return 'أذكار النوم';
    default: return id;
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
  final List<String> categoryIds;

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
    this.categoryIds = const ['general'],
  });

  bool get isCompleted => currentCount >= targetCount;

  bool isInCategory(String catId) => categoryIds.contains(catId);

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
    'categoryIds': categoryIds,
  };

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    List<String> cats;
    if (json.containsKey('categoryIds')) {
      cats = List<String>.from(json['categoryIds']);
    } else if (json.containsKey('category')) {
      cats = [json['category'] as String];
    } else {
      cats = ['general'];
    }
    return Dhikr(
      id: json['id'],
      text: json['text'],
      arabicName: json['arabicName'],
      neonColor: Color(json['neonColor']),
      targetCount: json['targetCount'],
      virtue: json['virtue'],
      currentCount: json['currentCount'] ?? 0,
      isCustom: json['isCustom'] ?? false,
      fontFamily: json['fontFamily'] ?? 'Cairo',
      categoryIds: cats,
    );
  }
}
