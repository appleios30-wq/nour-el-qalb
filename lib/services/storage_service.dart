import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_settings.dart';
import '../models/dhikr.dart';
import '../models/note.dart';

class StorageService {
  static const String _settingsBox = 'settings';
  static const String _adhkarBox = 'adhkar';
  static const String _customBox = 'custom';
  static const String _notesBox = 'notes';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _pinKey = 'notes_pin';
  static const String _fontSettingsKey = 'font_settings';

  // ===== الإعدادات =====
  static Future<void> saveSettings(UserSettings settings) async {
    final box = Hive.box(_settingsBox);
    await box.put('settings', settings.toJson());
  }

  static Future<UserSettings> getSettings() async {
    final box = Hive.box(_settingsBox);
    final data = box.get('settings');
    if (data != null) {
      return UserSettings.fromJson(Map<String, dynamic>.from(data));
    }
    return UserSettings();
  }

  // ===== الإعداد الأولي =====
  static Future<void> completeOnboarding() async {
    final box = Hive.box(_settingsBox);
    await box.put(_onboardingKey, true);
  }

  static Future<bool> hasCompletedOnboarding() async {
    final box = Hive.box(_settingsBox);
    return box.get(_onboardingKey, defaultValue: false);
  }

  // ===== الأذكار =====
  static Future<void> saveAdhkarProgress(List<Dhikr> adhkar) async {
    final box = Hive.box(_adhkarBox);
    final data = adhkar.map((d) => d.toJson()).toList();
    await box.put('progress', data);
  }

  static Future<Map<String, int>> getAdhkarProgress() async {
    final box = Hive.box(_adhkarBox);
    final data = box.get('progress');
    if (data != null) {
      return Map<String, int>.from(
        (data as List).fold({}, (map, item) {
          final itemMap = Map<String, dynamic>.from(item);
          map[itemMap['id']] = itemMap['currentCount'];
          return map;
        }),
      );
    }
    return {};
  }

  // ===== الأذكار المخصصة =====
  static Future<void> saveCustomDhikr(Dhikr dhikr) async {
    final box = Hive.box(_customBox);
    final existing = box.get('custom_dhikrs', defaultValue: <dynamic>[]);
    final list = List<Map<String, dynamic>>.from(existing);
    list.add(dhikr.toJson());
    await box.put('custom_dhikrs', list);
  }

  static Future<List<Dhikr>> getCustomDhikrs() async {
    final box = Hive.box(_customBox);
    final data = box.get('custom_dhikrs', defaultValue: <dynamic>[]);
    return (data as List)
        .map((item) => Dhikr.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<void> deleteCustomDhikr(String id) async {
    final box = Hive.box(_customBox);
    final existing = box.get('custom_dhikrs', defaultValue: <dynamic>[]);
    final list = List<Map<String, dynamic>>.from(existing);
    list.removeWhere((item) => item['id'] == id);
    await box.put('custom_dhikrs', list);
  }

  // ===== إعدادات الخطوط =====
  static Future<void> saveFontSettings(Map<String, String> settings) async {
    final box = Hive.box(_settingsBox);
    await box.put(_fontSettingsKey, settings);
  }

  static Future<Map<String, String>> getFontSettings() async {
    final box = Hive.box(_settingsBox);
    final data = box.get(_fontSettingsKey);
    if (data != null) {
      return Map<String, String>.from(data);
    }
    return {'general': 'Cairo', 'dhikr': 'Amiri'};
  }

  // ===== الملاحظات =====
  static Future<void> saveNotes(List<Note> notes) async {
    final box = Hive.box(_notesBox);
    final data = notes.map((n) => n.toJson()).toList();
    await box.put('notes', data);
  }

  static Future<List<Note>> getNotes() async {
    final box = Hive.box(_notesBox);
    final data = box.get('notes');
    if (data != null) {
      return (data as List)
          .map((item) => Note.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  // ===== الرقم السري =====
  static Future<void> savePin(String pin) async {
    final box = Hive.box(_notesBox);
    await box.put(_pinKey, pin);
  }

  static Future<String?> getPin() async {
    final box = Hive.box(_notesBox);
    return box.get(_pinKey);
  }

  // ===== مسح كل البيانات =====
  static Future<void> clearAll() async {
    await Hive.box(_settingsBox).clear();
    await Hive.box(_adhkarBox).clear();
    await Hive.box(_customBox).clear();
    await Hive.box(_notesBox).clear();
  }
}
