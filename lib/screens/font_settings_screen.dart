import 'package:flutter/material.dart';
import '../utils/neon_colors.dart';
import '../services/storage_service.dart';

class FontSettingsScreen extends StatefulWidget {
  const FontSettingsScreen({super.key});

  @override
  State<FontSettingsScreen> createState() => _FontSettingsScreenState();
}

class _FontSettingsScreenState extends State<FontSettingsScreen> {
  String _selectedFont = 'Cairo';
  String _selectedDhikrFont = 'Amiri';

  final List<_FontOption> _fonts = [
    _FontOption('Cairo', 'خط عصري حديث'),
    _FontOption('Amiri', 'خط عربي كلاسيكي'),
    _FontOption('Noto Naskh Arabic', 'خط نسخ واضح'),
    _FontOption('Reem Kufi', 'خط كوفي جميل'),
    _FontOption('Scheherazade New', 'خط تقليدي'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await StorageService.getFontSettings();
    setState(() {
      _selectedFont = settings['general'] ?? 'Cairo';
      _selectedDhikrFont = settings['dhikr'] ?? 'Amiri';
    });
  }

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
          child: Column(
            children: [
              // رأس الصفحة
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'إعدادات الخطوط',
                      style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 22),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الخط العام
                      _buildFontSection(
                        title: 'الخط العام للتطبيق',
                        subtitle: 'يستخدم في العناوين والنصوص العامة',
                        selected: _selectedFont,
                        onChanged: (v) => setState(() => _selectedFont = v),
                      ),
                      const SizedBox(height: 32),

                      // خط الأذكار
                      _buildFontSection(
                        title: 'خط الأذكار',
                        subtitle: 'يستخدم في نصوص الأذكار والتسبيح',
                        selected: _selectedDhikrFont,
                        onChanged: (v) => setState(() => _selectedDhikrFont = v),
                      ),
                      const SizedBox(height: 32),

                      // معاينة
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: NeonColors.darkCard.withOpacity( 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: NeonColors.gold.withOpacity( 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معاينة',
                              style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'سبحان الله وبحمده',
                              style: TextStyle(
                                fontFamily: _selectedDhikrFont,
                                color: NeonColors.cyan,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'نور قلبك',
                              style: TextStyle(
                                fontFamily: _selectedFont,
                                color: NeonColors.gold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // زر الحفظ
                      GestureDetector(
                        onTap: _saveFontSettings,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: NeonColors.getNeonGlow(NeonColors.gold),
                          ),
                          child: const Center(
                            child: Text(
                              'حفظ الإعدادات',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSection({
    required String title,
    required String subtitle,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: NeonColors.gold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity( 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        ..._fonts.map((font) {
          final isSelected = selected == font.name;
          return GestureDetector(
            onTap: () => onChanged(font.name),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? NeonColors.gold.withOpacity( 0.15)
                    : NeonColors.darkCard.withOpacity( 0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected
                      ? NeonColors.gold
                      : Colors.white.withOpacity( 0.1),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? NeonColors.getNeonGlow(NeonColors.gold, intensity: 0.3)
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? NeonColors.gold : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          font.name,
                          style: TextStyle(
                            color: isSelected ? NeonColors.gold : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: font.name,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          font.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity( 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: NeonColors.gold, size: 24),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _saveFontSettings() async {
    await StorageService.saveFontSettings({
      'general': _selectedFont,
      'dhikr': _selectedDhikrFont,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حفظ إعدادات الخطوط'),
        backgroundColor: NeonColors.green,
      ),
    );
  }
}

class _FontOption {
  final String name;
  final String description;
  const _FontOption(this.name, this.description);
}
