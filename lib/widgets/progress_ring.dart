import 'package:flutter/material.dart';
import '../utils/neon_colors.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final Color neonColor;
  final double size;
  final double strokeWidth;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.neonColor,
    this.size = 150,
    this.strokeWidth = 8,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: NeonColors.getNeonGlow(neonColor, intensity: 0.5),
      ),
      child: CustomPaint(
        painter: _ProgressRingPainter(
          progress: progress,
          color: neonColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // الخلفية
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // شريط التقدم
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
