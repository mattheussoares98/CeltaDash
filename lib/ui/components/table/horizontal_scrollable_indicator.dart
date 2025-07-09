import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class HorizontalScrollableIndicator extends StatefulWidget {
  const HorizontalScrollableIndicator({super.key});

  @override
  State<HorizontalScrollableIndicator> createState() =>
      _HorizontalScrollableIndicatorState();
}

class _HorizontalScrollableIndicatorState
    extends State<HorizontalScrollableIndicator> with TickerProviderStateMixin {
  late AnimationController _handAnimationController;
  late Animation<double> _handAnimation;

  @override
  void initState() {
    super.initState();

    _handAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    final screenSize =
        MediaQuery.of(NavigatorKey.key.currentState!.context).size;

    _handAnimation = Tween<double>(
            begin: -(screenSize.width * 0.1), end: screenSize.width * 0.4)
        .animate(
      _handAnimationController,
    );
  }

  @override
  void dispose() {
    _handAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _handAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_handAnimation.value, 0),
          child: const Icon(
            Icons.swipe_rounded,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0, 0),
                blurRadius: 1,
              ),
              Shadow(
                color: Colors.black,
                offset: Offset(-1, -1),
                blurRadius: 1,
              )
            ],
            size: 50,
            color: Color(0xFFE0AC69),
          ),
        );
      },
    );
  }
}
