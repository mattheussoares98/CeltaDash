import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  final AnimationController? _animationController;
  final TextStyle textStyle;

  const LogoImage({
    super.key,
    required AnimationController? animationController,
    required this.textStyle,
  }) : _animationController = animationController;

  @override
  Widget build(BuildContext context) {
    final widget = Hero(
      tag: 'logo',
      child: Image.asset(
        'lib/core/assets/images/CeltaLogo.png',
        height: 230,
        width: 230,
        cacheHeight: 230,
        cacheWidth: 250,
        fit: BoxFit.contain,
      ),
    );

    if (_animationController == null) {
      return widget;
    }
    // If animation is disabled, render static logo without animation
    final fontSize = textStyle.fontSize ?? 150.0;

    // Logo entrance scale: 0.0 -> 1.0 (0.0 to 0.20 duration)
    final logoScaleEntrance = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOutBack),
      ),
    );

    // Logo exit scale: 1.0 -> 2.2 (0.90 to 1.0 duration)
    final logoScaleExit = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.90, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Logo entrance translation: textWidth/2 -> 0.0 (0.20 to 0.40 duration)
    final logoTranslateEntrance = Tween<double>(begin: fontSize * 2.7, end: 0.0)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.20, 0.40, curve: Curves.easeInOut),
          ),
        );

    // Logo exit translation: 0.0 -> textWidth/2 (0.90 to 1.0 duration)
    final logoTranslateExit = Tween<double>(begin: 0.0, end: fontSize * 2.7)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.90, 1.0, curve: Curves.easeInOut),
          ),
        );

    // Logo exit opacity: 1.0 -> 0.0 (0.95 to 1.0 duration)
    final logoOpacityExit = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.95, 1.0, curve: Curves.easeIn),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double currentScale = _animationController.value < 0.90
            ? logoScaleEntrance.value
            : logoScaleExit.value;

        final double currentTranslationX = _animationController.value < 0.90
            ? logoTranslateEntrance.value
            : logoTranslateExit.value;

        final double currentOpacity = _animationController.value < 0.90
            ? 1.0
            : logoOpacityExit.value;

        return Opacity(
          opacity: currentOpacity,
          child: Transform.translate(
            offset: Offset(currentTranslationX, 0.0),
            child: Transform.scale(scale: currentScale, child: widget),
          ),
        );
      },
    );
  }
}
