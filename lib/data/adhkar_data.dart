import 'package:flutter/material.dart';
import '../models/dhikr.dart';

class AdhkarData {
  static List<Dhikr> get defaultAdhkar => [
    Dhikr(
      id: 'subhanallah',
      text: 'سبحان الله',
      arabicName: 'التسبيح',
      neonColor: const Color(0xFF00BFFF),
      targetCount: 33,
      virtue: 'من قالها مائة مرة حطت خطاياه وإن كانت مثل زبد البحر',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'alhamdulillah',
      text: 'الحمد لله',
      arabicName: 'الحمد',
      neonColor: const Color(0xFF00FF7F),
      targetCount: 33,
      virtue: 'أفضل الذكر الحمد لله',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'allahakbar',
      text: 'الله أكبر',
      arabicName: 'التكبير',
      neonColor: const Color(0xFFFFD700),
      targetCount: 34,
      virtue: 'كبائر السيئات تُمحى بالاستغفار',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'lailahaillallah',
      text: 'لا إله إلا الله',
      arabicName: 'التوحيد',
      neonColor: const Color(0xFF9400D3),
      targetCount: 100,
      virtue: 'أفضل ذكر وأعظم درجة',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'astaghfirallah',
      text: 'أستغفر الله',
      arabicName: 'الاستغفار',
      neonColor: const Color(0xFFFF69B4),
      targetCount: 100,
      virtue: 'من استغفر الله غفر الله له',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'subhanallahwabihamdihi',
      text: 'سبحان الله وبحمده',
      arabicName: 'التسبيح والحمد',
      neonColor: const Color(0xFFFF8C00),
      targetCount: 100,
      virtue: 'حبان له قلبتين من ذهب',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'subhanallahilazeem',
      text: 'سبحان الله العظيم',
      arabicName: 'التسبيح العظيم',
      neonColor: const Color(0xFF00CED1),
      targetCount: 100,
      virtue: 'كلمتان خفيفتان على اللسان ثقيلتان في الميزان',
      category: DhikrCategory.general,
    ),
    Dhikr(
      id: 'lahawlaquwwata',
      text: 'لا حول ولا قوة إلا بالله',
      arabicName: 'الحوقلة',
      neonColor: const Color(0xFFC0C0C0),
      targetCount: 100,
      virtue: 'كنز من كنوز الجنة',
      category: DhikrCategory.general,
    ),
  ];
}
