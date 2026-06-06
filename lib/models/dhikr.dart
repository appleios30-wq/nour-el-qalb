import 'package:flutter/material.dart';

class Dhikr {
  final String id;
  final String text;
  final String arabicName;
  final Color neonColor;
  final int targetCount;
  final String virtue;
  int currentCount;

  Dhikr({
    required this.id,
    required this.text,
    required this.arabicName,
    required this.neonColor,
    required this.targetCount,
    required this.virtue,
    this.currentCount = 0,
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
    'currentCount': currentCount,
  };

  factory Dhikr.fromJson(Map<String, dynamic> json) => Dhikr(
    id: json['id'],
    text: json['text'],
    arabicName: json['arabicName'],
    neonColor: Color(json['neonColor']),
    targetCount: json['targetCount'],
    virtue: json['virtue'],
    currentCount: json['currentCount'] ?? 0,
  );
}
