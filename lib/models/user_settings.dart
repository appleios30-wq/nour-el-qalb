class UserSettings {
  String gender;
  int age;
  String governorate;
  bool vibrationEnabled;
  int defaultTargetCount;

  UserSettings({
    this.gender = 'ذكر',
    this.age = 25,
    this.governorate = 'القاهرة',
    this.vibrationEnabled = true,
    this.defaultTargetCount = 33,
  });

  Map<String, dynamic> toJson() => {
    'gender': gender,
    'age': age,
    'governorate': governorate,
    'vibrationEnabled': vibrationEnabled,
    'defaultTargetCount': defaultTargetCount,
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    gender: json['gender'] ?? 'ذكر',
    age: json['age'] ?? 25,
    governorate: json['governorate'] ?? 'القاهرة',
    vibrationEnabled: json['vibrationEnabled'] ?? true,
    defaultTargetCount: json['defaultTargetCount'] ?? 33,
  );
}
