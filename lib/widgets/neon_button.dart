import 'package:flutter/material.dart';
import '../utils/neon_colors.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final Color neonColor;
  final VoidCallback onPressed;
  final bool isLarge;

  const NeonButton({
    super.key,
    required this.text,
    required this.neonColor,
    required this.onPressed,
    this.isLarge = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
            width: widget.isLarge ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isLarge ? 24 : 16,
              vertical: widget.isLarge ? 16 : 12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.neonColor.withOpacity(0.8),
                  widget.neonColor.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: NeonColors.getNeonGlow(widget.neonColor),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.isLarge ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    ),
   );
  }
}
