import 'package:flutter/material.dart';

class AnimationUtils {
  // Common animation durations
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration verySlowDuration = Duration(milliseconds: 800);

  // Common animation curves
  static const Curve bounceInCurve = Curves.bounceIn;
  static const Curve bounceOutCurve = Curves.bounceOut;
  static const Curve elasticInCurve = Curves.elasticIn;
  static const Curve elasticOutCurve = Curves.elasticOut;
  static const Curve easeCurve = Curves.ease;
  static const Curve easeInCurve = Curves.easeIn;
  static const Curve easeOutCurve = Curves.easeOut;
  static const Curve easeInOutCurve = Curves.easeInOut;
  static const Curve easeInOutCubicCurve = Curves.easeInOutCubic;

  // Slide animation helpers
  static Animation<Offset> createSlideAnimation({
    required AnimationController controller,
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOutCubic,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Fade animation helpers
  static Animation<double> createFadeAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeIn,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Scale animation helpers
  static Animation<double> createScaleAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.elasticOut,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Rotation animation helpers
  static Animation<double> createRotationAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.linear,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Color animation helpers
  static Animation<Color?> createColorAnimation({
    required AnimationController controller,
    required Color begin,
    required Color end,
    Curve curve = Curves.easeInOut,
  }) {
    return ColorTween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Staggered animation timing
  static Duration getStaggeredDelay(
    int index, {
    Duration baseDelay = const Duration(milliseconds: 100),
    int maxDelay = 500,
  }) {
    final delay = baseDelay.inMilliseconds * index;
    return Duration(milliseconds: delay.clamp(0, maxDelay));
  }

  // Common animation combinations
  static Widget slideUpFadeIn({
    required Widget child,
    required AnimationController controller,
    double slideDistance = 50.0,
    Duration? delay,
  }) {
    final slideAnimation = createSlideAnimation(
      controller: controller,
      begin: Offset(0, slideDistance / 100),
      end: Offset.zero,
    );

    final fadeAnimation = createFadeAnimation(
      controller: controller,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  static Widget scaleIn({
    required Widget child,
    required AnimationController controller,
    double beginScale = 0.8,
    Curve curve = Curves.elasticOut,
  }) {
    final scaleAnimation = createScaleAnimation(
      controller: controller,
      begin: beginScale,
      end: 1.0,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        );
      },
    );
  }

  static Widget slideInFromRight({
    required Widget child,
    required AnimationController controller,
    double slideDistance = 1.0,
  }) {
    final slideAnimation = createSlideAnimation(
      controller: controller,
      begin: Offset(slideDistance, 0),
      end: Offset.zero,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  static Widget slideInFromLeft({
    required Widget child,
    required AnimationController controller,
    double slideDistance = 1.0,
  }) {
    final slideAnimation = createSlideAnimation(
      controller: controller,
      begin: Offset(-slideDistance, 0),
      end: Offset.zero,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  // Bounce animation
  static Widget bounceIn({
    required Widget child,
    required AnimationController controller,
  }) {
    final bounceAnimation = createScaleAnimation(
      controller: controller,
      begin: 0.0,
      end: 1.0,
      curve: Curves.bounceOut,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.scale(
          scale: bounceAnimation.value,
          child: child,
        );
      },
    );
  }

  // Shake animation
  static Widget shake({
    required Widget child,
    required AnimationController controller,
    double shakeDistance = 10.0,
  }) {
    final shakeAnimation = Tween<double>(
      begin: -shakeDistance,
      end: shakeDistance,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(shakeAnimation.value, 0),
          child: child,
        );
      },
    );
  }

  // Pulse animation
  static Widget pulse({
    required Widget child,
    required AnimationController controller,
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    final pulseAnimation = Tween<double>(
      begin: minScale,
      end: maxScale,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.scale(
          scale: pulseAnimation.value,
          child: child,
        );
      },
    );
  }

  // Floating animation
  static Widget floating({
    required Widget child,
    required AnimationController controller,
    double floatDistance = 10.0,
  }) {
    final floatAnimation = Tween<double>(
      begin: 0.0,
      end: floatDistance,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, -floatAnimation.value),
          child: child,
        );
      },
    );
  }

  // Custom interval animation
  static Animation<T> createIntervalAnimation<T>({
    required AnimationController controller,
    required Tween<T> tween,
    required double begin,
    required double end,
    Curve curve = Curves.linear,
  }) {
    return tween.animate(CurvedAnimation(
      parent: controller,
      curve: Interval(begin, end, curve: curve),
    ));
  }

  // Page transition animations
  static PageRouteBuilder createSlidePageRoute({
    required Widget page,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, _) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: end,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder createFadePageRoute({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, _) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder createScalePageRoute({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, _) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, _, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }
}
