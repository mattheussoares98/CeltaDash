import 'dart:math';

import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A clock that paints the passed portion of the day as a filled pie slice.
class DayProgressClock extends StatefulWidget {
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
  DayProgressClockState createState() => DayProgressClockState();
}

class DayProgressClockState extends State<DayProgressClock> {
  late bool _isCurrentDay;
  late DateTime? _displayTime;
  // Timer? _timer;

  @override
  void initState() {
    super.initState();
    // _setupClock();
  }

  @override
  void didUpdateWidget(covariant DayProgressClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.date != oldWidget.date) {
    //   _timer?.cancel();
    //   _setupClock();
    // }
  }

  // void _setupClock() {
  //   _timer?.cancel();
  //   final now = DateTime.now();
  // _isCurrentDay = widget.date.year == now.year &&
  //       widget.date.month == now.month &&
  //       widget.date.day == now.day;

  //   if (_isCurrentDay) {
  //     _displayTime = now;
  //     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //       if (mounted) setState(() => _displayTime = DateTime.now());
  //     });
  //   } else {
  //     _timer = null;
  //     _displayTime = DateTime(
  //       widget.date.year,
  //       widget.date.month,
  //       widget.date.day,
  //       23,
  //       59,
  //       59,
  //     );
  //   }
  // }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    _isCurrentDay =
        widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;

    if (_isCurrentDay) {
      _displayTime = widget.date;
    } else {
      _displayTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        23,
        59,
        59,
      );
    }

    const totalSeconds = 24 * 3600;
    final passedSeconds = _isCurrentDay
        ? _displayTime!.hour * 3600 +
              _displayTime!.minute * 60 +
              _displayTime!.second
        : totalSeconds;
    final fraction = passedSeconds / totalSeconds;
    final timeString = DateFormat.Hm().format(_displayTime!);

    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.radius * 2, widget.radius * 2),
            painter: _DayProgressPainter(
              fraction: fraction,
              passedColor: widget.passedColor,
              remainingColor: widget.remainingColor,
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
