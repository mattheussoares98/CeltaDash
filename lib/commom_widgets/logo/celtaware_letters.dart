import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

import 'logo.dart';

class CeltawareLetters extends StatelessWidget {
  final TextStyle textStyle;
  final AnimationController? _animationController;

  const CeltawareLetters({
    super.key,
    required this.textStyle,
    required AnimationController? animationController,
  }) : _animationController = animationController;

  @override
  Widget build(BuildContext context) {
    final celtaStyle = textStyle.copyWith(color: Colors.red[700]);

    if (_animationController == null) {
      return IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Celta'.hardcoded, style: celtaStyle),
            CustomWAndAtWidget(style: textStyle),
            Text('re'.hardcoded, style: textStyle),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Staggered letters fade & slide-in sequence
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.30,
            end: 0.45,
            child: Text('C'.hardcoded, style: celtaStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.33,
            end: 0.48,
            child: Text('e'.hardcoded, style: celtaStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.36,
            end: 0.51,
            child: Text('l'.hardcoded, style: celtaStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.39,
            end: 0.54,
            child: Text('t'.hardcoded, style: celtaStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.42,
            end: 0.57,
            child: Text('a'.hardcoded, style: celtaStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.45,
            end: 0.60,
            child: CustomWAndAtWidget(style: textStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.48,
            end: 0.63,
            child: Text('r'.hardcoded, style: textStyle),
          ),
          AnimatedLetterWidget(
            controller: _animationController,
            start: 0.51,
            end: 0.66,
            child: Text('e'.hardcoded, style: textStyle),
          ),
        ],
      ),
    );
  }
}
