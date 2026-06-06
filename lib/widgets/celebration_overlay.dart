import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CelebrationOverlay extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onDismiss;

  const CelebrationOverlay({
    super.key,
    required this.isVisible,
    this.onDismiss,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
      _confettiController.play();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            children: [
              // الخلفية المعتمة
              Container(
                color: Colors.black.withOpacity(0.7),
              ),
              // الشرارات
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.yellow,
                    Colors.orange,
                    Colors.pink,
                    Colors.blue,
                    Colors.green,
                    Colors.purple,
                  ],
                  emissionFrequency: 0.05,
                  numberOfParticles: 30,
                  gravity: 0.1,
                ),
              ),
              // رسالة التهنئة
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.celebration,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ما شاء الله!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        shadows: [
                          Shadow(
                            color: Colors.amber.withOpacity(0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'لقد أكملت العدد المطلوب',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        widget.onDismiss?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFF8C00),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Text(
                          'ابدأ دورة جديدة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
