import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class AnimatedPriceValue extends StatefulWidget {
  final num value;
  final TextStyle? style;
  final String priceText;

  const AnimatedPriceValue({
    super.key,
    required this.value,
    required this.style,
    required this.priceText,
  });

  @override
  State<AnimatedPriceValue> createState() => _AnimatedPriceValueState();
}

class _AnimatedPriceValueState extends State<AnimatedPriceValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(
      begin: Colors.green,
      end: widget.style?.color,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedPriceValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
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
    final defaultColor =
        widget.style?.color ?? context.theme.textTheme.bodyMedium?.color;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final color = _colorAnimation.value ?? defaultColor;
          final animatedStyle = widget.style?.copyWith(color: color);

          return Transform.scale(
            scale: _scaleAnimation.value,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: animatedStyle,
                children: [
                  TextSpan(
                    text: 'R\$ ',
                    style: animatedStyle?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(text: widget.priceText),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
