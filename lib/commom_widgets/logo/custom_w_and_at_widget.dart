import 'package:flutter/material.dart';

class CustomWAndAtWidget extends StatelessWidget {
  final TextStyle style;

  const CustomWAndAtWidget({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    final fontSize = style.fontSize ?? 150.0;
    final wWidth = fontSize * 0.78;
    final lineWidth = fontSize * 0.55;

    return Stack(
      children: [
        CustomPaint(
          size: Size((wWidth + lineWidth), fontSize * .8),
          painter: WVectorAndLinePainter(
            fontSize: fontSize,
            color: style.color ?? Colors.black,
          ),
        ),
        Positioned(
          left: wWidth,
          child: Text('@', style: style.copyWith(fontSize: fontSize * 0.6)),
        ),
      ],
    );
  }
}

class WVectorAndLinePainter extends CustomPainter {
  final double fontSize;
  final Color color;

  WVectorAndLinePainter({required this.fontSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final wWidth = fontSize * 0.85;
    final wHeight = fontSize * 0.8;
    final strokeWidth = fontSize * 0.11; // Bold stroke thickness
    final lineWidth = fontSize * 0.5; // Extends over the @ symbol

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final halfStroke = strokeWidth / 2;

    // Define vertices of the W with flat "square" bottom segments
    final p0 = Offset(halfStroke, halfStroke); // Top-left
    final p1A = Offset(
      wWidth * 0.16 + halfStroke,
      wHeight - halfStroke,
    ); // Bottom-left-start
    final p1B = Offset(
      wWidth * 0.32 - halfStroke,
      wHeight - halfStroke,
    ); // Bottom-left-end
    final p2 = Offset(wWidth * 0.50, wHeight * 0.28); // Middle-top peak
    final p3A = Offset(
      wWidth * 0.68 + halfStroke,
      wHeight - halfStroke,
    ); // Bottom-right-start
    final p3B = Offset(
      wWidth * 0.84 - halfStroke,
      wHeight - halfStroke,
    ); // Bottom-right-end
    final p4 = Offset(wWidth - halfStroke, halfStroke); // Top-right

    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1A.dx, p1A.dy)
      ..lineTo(p1B.dx, p1B.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3A.dx, p3A.dy)
      ..lineTo(p3B.dx, p3B.dy)
      ..lineTo(p4.dx, p4.dy);

    canvas.drawPath(path, paint);

    // Draw the horizontal continuation line starting at the center of the right peak (p4)
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // Soft round ending cap for premium look

    canvas.drawLine(p4, Offset(p4.dx + lineWidth, p4.dy), linePaint);
  }

  @override
  bool shouldRepaint(covariant WVectorAndLinePainter oldDelegate) {
    return oldDelegate.fontSize != fontSize || oldDelegate.color != color;
  }
}
