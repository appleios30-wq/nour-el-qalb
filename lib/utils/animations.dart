import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppAnimations {
  static Duration get fast => 200.milliseconds;
  static Duration get normal => 400.milliseconds;
  static Duration get slow => 600.milliseconds;

  static void pulseAnimation(AnimationController controller) {
    controller.repeat(reverse: true);
  }
}
