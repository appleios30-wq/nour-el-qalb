enum TimeOfDay {
  morning,
  afternoon,
  evening,
  night,
}

class TimeService {
  static TimeOfDay getCurrentTimeOfDay() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return TimeOfDay.morning;
    } else if (hour >= 12 && hour < 17) {
      return TimeOfDay.afternoon;
    } else if (hour >= 17 && hour < 20) {
      return TimeOfDay.evening;
    } else {
      return TimeOfDay.night;
    }
  }

  static bool isMorning() {
    final hour = DateTime.now().hour;
    return hour >= 5 && hour < 12;
  }

  static bool isEvening() {
    final hour = DateTime.now().hour;
    return hour >= 17 && hour < 20;
  }

  static bool isNight() {
    final hour = DateTime.now().hour;
    return hour >= 20 || hour < 5;
  }

  static String getTimeGreeting() {
    switch (getCurrentTimeOfDay()) {
      case TimeOfDay.morning:
        return 'صباح الخير';
      case TimeOfDay.afternoon:
        return 'مساء الخير';
      case TimeOfDay.evening:
        return 'مساء الخير';
      case TimeOfDay.night:
        return 'مساء الخير';
    }
  }

  static String getBackgroundType() {
    switch (getCurrentTimeOfDay()) {
      case TimeOfDay.morning:
        return 'morning';
      case TimeOfDay.afternoon:
        return 'afternoon';
      case TimeOfDay.evening:
        return 'evening';
      case TimeOfDay.night:
        return 'night';
    }
  }

  static String getRayColor() {
    if (isMorning()) {
      return 'orange'; // برتقالي متوهج
    } else {
      return 'white_blue'; // أبيض مزرق مضيء
    }
  }
}
