import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../utils/neon_colors.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final VoidCallback onTap;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NeonColors.darkCard.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dhikr.neonColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: dhikr.isCompleted
              ? NeonColors.getNeonGlow(dhikr.neonColor, intensity: 1.5)
              : [],
        ),
        child: Row(
          children: [
            // أيقونة الذكر
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dhikr.neonColor.withOpacity(0.2),
                border: Border.all(
                  color: dhikr.neonColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${dhikr.currentCount}',
                  style: NeonColors.getNeonTextStyle(
                    dhikr.neonColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // نص الذكر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dhikr.text,
                    style: TextStyle(
                      color: dhikr.neonColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: dhikr.neonColor.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dhikr.virtue,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // شريط التقدم
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: dhikr.targetCount > 0
                    ? dhikr.currentCount / dhikr.targetCount
                    : 0,
                backgroundColor: dhikr.neonColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(dhikr.neonColor),
                strokeWidth: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
