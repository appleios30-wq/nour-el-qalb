import 'package:flutter/material.dart';
import '../models/user_settings.dart';
import '../services/storage_service.dart';
import '../widgets/neon_button.dart';
import '../utils/neon_colors.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _selectedGender = 'ذكر';
  int _age = 25;
  String _selectedGovernorate = 'القاهرة';
  
  final List<String> _governorates = [
    'القاهرة', 'الجيزة', 'الإسكندرية', 'القليوبية', 'الشرقية',
    'الغربية', 'المنوفية', 'البحيرة', 'كفر الشيخ', 'دمياط',
    'الفيوم', 'بني سويف', 'المنيا', 'أسيوط', 'سوهاج',
    'قنا', 'الأقصر', 'أسوان', 'البحر الأحمر', 'الوادي الجديد',
    'مطروح', 'شمال سيناء', 'جنوب سيناء',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0a0a1a),
              Color(0xFF1a0a2a),
              Color(0xFF0a0a1a),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شعار التطبيق
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00d4ff).withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.nightlight_round,
                      size: 80,
                      color: Color(0xFF00d4ff),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // اسم التطبيق
                  Text(
                    'نور قلبك',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFffd966),
                      shadows: [
                        Shadow(
                          color: const Color(0xFFffd966).withOpacity(0.8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'أذكارك اليومية',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // اختيار الجنس
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NeonColors.darkCard.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: NeonColors.gold.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'اختر الجنس',
                          style: NeonColors.getNeonTextStyle(
                            NeonColors.gold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildGenderButton('ذكر', Icons.male),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildGenderButton('أنثى', Icons.female),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // إدخال العمر
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NeonColors.darkCard.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: NeonColors.green.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'العمر',
                          style: NeonColors.getNeonTextStyle(
                            NeonColors.green,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          value: _age.toDouble(),
                          min: 10,
                          max: 80,
                          activeColor: NeonColors.green,
                          inactiveColor: NeonColors.green.withOpacity(0.2),
                          onChanged: (value) {
                            setState(() {
                              _age = value.round();
                            });
                          },
                        ),
                        Text(
                          '$_age سنة',
                          style: NeonColors.getNeonTextStyle(
                            NeonColors.green,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // اختيار المحافظة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NeonColors.darkCard.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: NeonColors.purple.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'المحافظة',
                          style: NeonColors.getNeonTextStyle(
                            NeonColors.purple,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: NeonColors.purple.withOpacity(0.3),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGovernorate,
                              isExpanded: true,
                              dropdownColor: NeonColors.darkCard,
                              style: const TextStyle(color: Colors.white),
                              items: _governorates.map((gov) {
                                return DropdownMenuItem(
                                  value: gov,
                                  child: Text(gov),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGovernorate = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // زر البدء
                  NeonButton(
                    text: 'ابدأ رحلتك',
                    neonColor: NeonColors.gold,
                    isLarge: true,
                    onPressed: _startJourney,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? NeonColors.gold.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? NeonColors.gold : NeonColors.gold.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected ? NeonColors.getNeonGlow(NeonColors.gold) : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? NeonColors.gold : Colors.white54,
            ),
            const SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? NeonColors.gold : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startJourney() async {
    final settings = UserSettings(
      gender: _selectedGender,
      age: _age,
      governorate: _selectedGovernorate,
    );

    await StorageService.saveSettings(settings);
    await StorageService.completeOnboarding();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
