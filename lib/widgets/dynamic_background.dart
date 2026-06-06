import 'package:flutter/material.dart';
import '../services/time_service.dart';

class DynamicBackground extends StatelessWidget {
  final String? customBackground;

  const DynamicBackground({super.key, this.customBackground});

  @override
  Widget build(BuildContext context) {
    final bgType = customBackground ?? TimeService.getBackgroundType();

    return Container(
      decoration: BoxDecoration(
        gradient: _getGradient(bgType),
      ),
      child: CustomPaint(
        painter: _BackgroundPainter(bgType: bgType),
        child: Container(),
      ),
    );
  }

  LinearGradient _getGradient(String bgType) {
    switch (bgType) {
      case 'morning':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a0a2a),
            Color(0xFF0a0a1a),
          ],
        );
      case 'afternoon':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2a0a1a),
            Color(0xFF0a0a1a),
          ],
        );
      case 'evening':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2a1a0a),
            Color(0xFF0a0a1a),
          ],
        );
      case 'night':
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0a0a2a),
            Color(0xFF0a0a1a),
          ],
        );
    }
  }
}

class _BackgroundPainter extends CustomPainter {
  final String bgType;

  _BackgroundPainter({required this.bgType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1);

    // رسم النجوم
    for (int i = 0; i < 100; i++) {
      final x = (i * 13.7) % size.width;
      final y = (i * 7.3) % size.height;
      final radius = (i % 3) * 0.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // رسم القمر في الليل
    if (bgType == 'night') {
      final moonPaint = Paint()
        ..color = Colors.white.withOpacity(0.8);
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.15),
        30,
        moonPaint,
      );
      
      final moonShadowPaint = Paint()
        ..color = const Color(0xFF0a0a2a);
      canvas.drawCircle(
        Offset(size.width * 0.8 + 10, size.height * 0.15),
        28,
        moonShadowPaint,
      );
    }

    // رسم الشمس في الصباح
    if (bgType == 'morning') {
      final sunPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFB347).withOpacity(0.8),
            const Color(0xFFFFB347).withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.2, size.height * 0.1),
          radius: 60,
        ));
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.1),
        60,
        sunPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
