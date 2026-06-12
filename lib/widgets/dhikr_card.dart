import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../utils/neon_colors.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool editMode;
  final Widget? leading;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.editMode = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onEdit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: NeonColors.darkCard.withOpacity(0.85),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: dhikr.neonColor.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: dhikr.isCompleted
              ? NeonColors.getNeonGlow(dhikr.neonColor, intensity: 1.2)
              : [],
        ),
        child: Row(
          children: [
            if (leading != null) leading!,
            // نص الذكر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dhikr.text,
                          style: TextStyle(
                            color: dhikr.neonColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: dhikr.fontFamily,
                            shadows: [
                              Shadow(
                                color: dhikr.neonColor.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (editMode && onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: NeonColors.gold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.edit, color: NeonColors.gold, size: 16),
                          ),
                        ),
                      if (editMode && onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 16),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // عدد التكرارات
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: dhikr.neonColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${dhikr.currentCount}/${dhikr.targetCount}',
                          style: TextStyle(
                            color: dhikr.neonColor.withOpacity(0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // اسم الذكر
                      Expanded(
                        child: Text(
                          dhikr.arabicName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // فضيلة
                      if (dhikr.virtue.isNotEmpty && dhikr.virtue != 'ذكر مخصص')
                        Expanded(
                          child: Text(
                            dhikr.virtue,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // أيقونة زخرفية + شريط التقدم
            Column(
              children: [
                _buildDecorativeIcon(),
                const SizedBox(height: 6),
                _buildMiniProgress(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dhikr.neonColor.withOpacity(0.12),
        border: Border.all(color: dhikr.neonColor.withOpacity(0.5), width: 1.5),
      ),
      child: CustomPaint(
        painter: _StarPainter(color: dhikr.neonColor.withOpacity(0.7)),
        child: Center(
          child: Text(
            '${dhikr.currentCount}',
            style: NeonColors.getNeonTextStyle(dhikr.neonColor, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniProgress() {
    return SizedBox(
      width: 48,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: dhikr.targetCount > 0
              ? dhikr.currentCount / dhikr.targetCount
              : 0,
          backgroundColor: dhikr.neonColor.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation<Color>(dhikr.neonColor),
          minHeight: 4,
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * 3.14159 / 180;
      final nextAngle = ((i + 1) * 45 - 90) * 3.14159 / 180;
      final px = cx + r * _cos(angle);
      final py = cy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
      final midR = i % 2 == 0 ? r * 0.55 : r;
      final midAngle = ((i + 0.5) * 45 - 90) * 3.14159 / 180;
      final mx = cx + midR * _cos(midAngle);
      final my = cy + midR * _sin(midAngle);
      path.lineTo(mx, my);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
