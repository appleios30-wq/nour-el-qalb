import 'package:flutter/material.dart';

class RayEffect extends StatefulWidget {
  final Color rayColor;
  final Color sparkColor;
  final bool isActive;

  const RayEffect({
    super.key,
    required this.rayColor,
    required this.sparkColor,
    this.isActive = false,
  });

  @override
  State<RayEffect> createState() => _RayEffectState();
}

class _RayEffectState extends State<RayEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void didUpdateWidget(RayEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.rayColor.withOpacity(0.8),
                    widget.rayColor.withOpacity(0.4),
                    widget.rayColor.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
