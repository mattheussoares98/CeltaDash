import 'package:flutter/material.dart';

class AnimatedLetterWidget extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final double start;
  final double end;

  const AnimatedLetterWidget({
    super.key,
    required this.child,
    required this.controller,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final fadeEntrance = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      ),
    );

    final slideEntrance =
        Tween<Offset>(begin: const Offset(3, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        );

    final fadeExit = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.90, 0.98, curve: Curves.easeIn),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, childWidget) {
        return Opacity(
          opacity: (fadeEntrance.value * fadeExit.value).clamp(0.0, 1.0),
          child: FractionalTranslation(
            translation: slideEntrance.value,
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }
}
