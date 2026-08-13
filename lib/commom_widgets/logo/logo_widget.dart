import 'package:celta_dash/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import 'logo.dart';

class LogoWidget extends StatefulWidget {
  final bool animate;
  final VoidCallback? onAnimationComplete;
  final Duration? animationDuration;
  const LogoWidget({
    super.key,
    this.animate = false,
    this.onAnimationComplete,
    this.animationDuration,
  });

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    if (widget.animate && mounted) {
      _animationController = AnimationController(
        vsync: this,
        duration:
            widget.animationDuration ?? const Duration(milliseconds: 3500),
      );
      _animationController!.forward();
      _animationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 150.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Center(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoImage(
              animationController: _animationController,
              textStyle: textStyle,
            ),
            gapW16,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CeltawareLetters(
                  textStyle: textStyle,
                  animationController: _animationController,
                ),
                TechnologyAndSolutions(
                  animationController: _animationController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
