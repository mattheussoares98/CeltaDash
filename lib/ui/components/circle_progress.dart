import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

class CircleProgress extends StatelessWidget {
  final double value;
  final double maximum;
  final double height;
  final double width;
  const CircleProgress({
    super.key,
    required this.value,
    required this.maximum,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(width, height),
          painter: _ProgressCirclePainter(
            progress: value / maximum,
            backgroundColor: Theme.of(context).primaryColorLight.withAlpha(15),
            progressColor: Colors.green,
          ),
        ),
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              value.toString().toBrazilianNumber().addBrazilianCoin(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
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
    final Paint backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10;

    final Paint progressPaint =
        Paint()
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
