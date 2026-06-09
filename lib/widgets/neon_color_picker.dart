import 'package:flutter/material.dart';
import '../utils/neon_colors.dart';

class NeonColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const NeonColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  static const List<Color> colors = [
    Color(0xFF00BFFF),
    Color(0xFF00FF7F),
    Color(0xFFFFD700),
    Color(0xFF9400D3),
    Color(0xFFFF69B4),
    Color(0xFFFF8C00),
    Color(0xFF00CED1),
    Color(0xFFC0C0C0),
    Color(0xFFFF0000),
    Color(0xFF00FF00),
    Color(0xFFFFFFFF),
    Color(0xFFFF4500),
    Color(0xFF7B68EE),
    Color(0xFF00FA9A),
    Color(0xFFFF1493),
    Color(0xFF00FFFF),
    Color(0xFF32CD32),
    Color(0xFFFFD700),
    Color(0xFF8A2BE2),
    Color(0xFF1E90FF),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر لون النيون',
          style: NeonColors.getNeonTextStyle(NeonColors.gold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeonColors.darkCard.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selectedColor,
              width: 2,
            ),
            boxShadow: NeonColors.getNeonGlow(selectedColor, intensity: 0.5),
          ),
          child: Column(
            children: [
              // معاينة اللون
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedColor,
                      boxShadow: NeonColors.getNeonGlow(selectedColor, intensity: 1.0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'معاينة النيون',
                      style: TextStyle(
                        color: selectedColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: selectedColor.withOpacity( 0.8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // شبكة الألوان
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: colors.map((color) {
                  final isSelected = color.value == selectedColor.value;
                  return GestureDetector(
                    onTap: () => onColorChanged(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? NeonColors.getNeonGlow(color, intensity: 1.0)
                            : [BoxShadow(
                                color: color.withOpacity( 0.3),
                                blurRadius: 5,
                              )],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
