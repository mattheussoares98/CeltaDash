import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class TechnologyAndSolutions extends StatelessWidget {
  final AnimationController? _animationController;

  const TechnologyAndSolutions({
    super.key,
    required AnimationController? animationController,
  }) : _animationController = animationController;

  @override
  Widget build(BuildContext context) {
    final widget = Text(
      'Tecnologia & Soluções'.hardcoded,
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        letterSpacing: 2.0,
      ),
    );

    if (_animationController == null) {
      return widget;
    }
    // Tagline reveal slide: 100.0 -> 0.0 (0.5 to 0.85 duration)
    final taglineSlide = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Tagline reveal opacity: 0.0 -> 1.0 (0.5 to 0.75 duration)
    final taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.75, curve: Curves.easeIn),
      ),
    );

    // Tagline exit slide: 0.0 -> 30.0 (0.90 to 1.0 duration)
    final taglineExitSlide = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.90, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Tagline exit opacity: 1.0 -> 0.0 (0.90 to 0.96 duration)
    final taglineExitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.90, 0.96, curve: Curves.easeIn),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double currentSlide = _animationController.value < 0.90
            ? taglineSlide.value
            : taglineExitSlide.value;

        final double currentOpacity = _animationController.value < 0.90
            ? taglineOpacity.value
            : taglineExitOpacity.value;

        return Opacity(
          opacity: currentOpacity,
          child: Transform.translate(
            offset: Offset(0.0, currentSlide),
            child: widget,
          ),
        );
      },
    );
  }
}
