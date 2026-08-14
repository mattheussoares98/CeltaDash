import 'dart:math';

import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A clock that paints the passed portion of the day as a filled pie slice.
class DayProgressClock extends StatelessWidget {
  /// The date to represent (if not today, will show as completed).
  final DateTime date;

  /// Radius of the clock circle.
  final double radius;

  /// Color for the passed slice.
  final Color passedColor;

  /// Color for the remaining area.
  final Color remainingColor;

  const DayProgressClock({
    super.key,
    required this.date,
    this.radius = 40,
    this.passedColor = Colors.blue,
    this.remainingColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentDay =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final displayTime = isCurrentDay
        ? date
        : DateTime(date.year, date.month, date.day, 23, 59, 59);

    const totalSeconds = 24 * 3600;
    final passedSeconds = isCurrentDay
        ? displayTime.hour * 3600 +
              displayTime.minute * 60 +
              displayTime.second
        : totalSeconds;
    final fraction = passedSeconds / totalSeconds;
    final timeString = DateFormat.Hm().format(displayTime);

    final diameter = radius * 2;

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(diameter, diameter),
            painter: _DayProgressPainter(
              fraction: fraction,
              passedColor: passedColor,
              remainingColor: remainingColor,
            ),
          ),
          Text(
            "${R.string.until}\n$timeString",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _DayProgressPainter extends CustomPainter {
  final double fraction;
  final Color passedColor;
  final Color remainingColor;

  _DayProgressPainter({
    required this.fraction,
    required this.passedColor,
    required this.remainingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * fraction;

    final paintRemaining = Paint()..color = remainingColor;
    canvas.drawCircle(center, radius, paintRemaining);

    final paintPassed = Paint()..color = passedColor;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paintPassed);
  }

  @override
  bool shouldRepaint(covariant _DayProgressPainter old) {
    return old.fraction != fraction ||
        old.passedColor != passedColor ||
        old.remainingColor != remainingColor;
  }
}
