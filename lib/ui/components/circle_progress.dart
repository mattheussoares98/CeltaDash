import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

class AnimatedCircleProgress extends StatefulWidget {
  final double value;
  final double maximum;
  final double height;
  final double width;
  final ScrollController
      scrollController; //need to repeat the animation when hide from the page and appears agein

  const AnimatedCircleProgress({
    super.key,
    required this.value,
    required this.maximum,
    required this.height,
    required this.width,
    required this.scrollController,
  });

  @override
  State<AnimatedCircleProgress> createState() => _AnimatedCircleProgressState();
}

class _AnimatedCircleProgressState extends State<AnimatedCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  final GlobalKey _widgetKey = GlobalKey();
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.value / widget.maximum,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());

    widget.scrollController.addListener(_checkVisibility);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.scrollController.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      final screenHeight = MediaQuery.of(context).size.height;

      final isVisible =
          position.dy < screenHeight && (position.dy + size.height) > 0;

      if (isVisible && !_hasAnimated) {
        _controller.reset();
        _controller.forward();
        _hasAnimated = true;
      } else if (!isVisible) {
        _hasAnimated =
            false; // Se sumiu, permite animar novamente quando voltar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reset();
        _controller.forward();
        _hasAnimated = true;
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        key: _widgetKey,
        child: LayoutBuilder(builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _ProgressCirclePainter(
                      progress: _progressAnimation.value,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColorLight.withAlpha(100),
                      progressColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.7,
                    height: constraints.maxHeight * 0.7,
                    child: FittedBox(
                      child: Text(
                        widget.value
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressCirclePainter({
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.green,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 5) / 2;

    // fundo
    canvas.drawCircle(center, radius, backgroundPaint);

    // arco do progresso
    final double sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
