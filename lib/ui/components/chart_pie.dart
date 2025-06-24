import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ui/helpers/helpers.dart';

/// A pie chart widget that can optionally show a day-progress clock in its center hole.
class ChartPie extends StatefulWidget {
  final List<PieParameter> pieParameters;
  final int? quantityToShow;
  final BoxShape? itemsShape;
  final EdgeInsetsGeometry? paddingItems;
  final bool? showTotalAmount;

  /// Date for the clock: if null, no clock; if not today's date, shows completed.
  final DateTime? centerDate;

  /// Radius of the center hole (and clock).
  final double centerSpaceRadius;

  /// Color for the passed slice in the clock.
  final Color centerPassedColor;

  /// Color for the remaining slice in the clock.
  final Color centerRemainingColor;

  const ChartPie({
    super.key,
    required this.pieParameters,
    this.itemsShape = BoxShape.circle,
    this.quantityToShow,
    this.paddingItems,
    this.showTotalAmount = true,
    this.centerDate,
    this.centerSpaceRadius = 40,
    this.centerPassedColor = Colors.blue,
    this.centerRemainingColor = const Color(0xFFE0E0E0),
  });

  @override
  State<ChartPie> createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPie> {
  int? selectedIndex;
  double indicatorSize = 16;
  final colors = [
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.deepOrange,
    Colors.red,
    Colors.brown,
    Colors.teal,
    Colors.cyanAccent,
  ];

  bool needBreakLoop(int index) =>
      index > (widget.quantityToShow ?? 4) || (index + 1) > colors.length;

  List<PieChartSectionData> getSections(double chartWidth) {
    double total = widget.pieParameters.fold<double>(0, (p, e) => p + e.value);

    if (total == 0) {
      total = 0.001;
    }
    return List.generate(
      widget.pieParameters.length,
      (i) {
        if (needBreakLoop(i)) return null;
        final param = widget.pieParameters[i];
        final isTouched = i == selectedIndex;
        final radius = chartWidth * (isTouched ? 0.23 : 0.2);
        return PieChartSectionData(
          color: param.color ?? colors[i],
          value: param.value == 0 && i == 1 ? 0.01 : param.value,
          title:
              '${(param.value / total * 100).toString().toBrazilianNumber(0)}%',
          radius: radius,
          titleStyle: Theme.of(context).textTheme.titleSmall,
        );
      },
    ).whereType<PieChartSectionData>().toList();
  }

  List<_Indicator> getIndicators() {
    return List.generate(
      widget.pieParameters.length,
      (i) {
        if (needBreakLoop(i)) return null;
        final param = widget.pieParameters[i];
        return _Indicator(
          title: param.title,
          subtitle: param.subtitle,
          value: param.value,
          color: param.color ?? colors[i],
          boxShape: widget.itemsShape!,
          padding: widget.paddingItems,
          isSelected: i == selectedIndex,
          indicatorSize: indicatorSize,
          changeSelectedIndex: () => setState(() => selectedIndex = i),
        );
      },
    ).whereType<_Indicator>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartSize = MediaQuery.of(context).size.width * 0.4;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (e, resp) {
                            final idx =
                                resp?.touchedSection?.touchedSectionIndex;
                            if (e.isInterestedForInteractions &&
                                idx != null &&
                                idx >= 0) {
                              setState(() => selectedIndex = idx);
                            }
                          },
                        ),
                        borderData: null,
                        sectionsSpace: 3,
                        centerSpaceRadius: widget.centerSpaceRadius,
                        centerSpaceColor: Colors.transparent,
                        sections: getSections(chartSize),
                        startDegreeOffset: 180,
                      ),
                    ),
                    if (widget.centerDate != null)
                      DayProgressClock(
                        date: widget.centerDate!,
                        radius: widget.centerSpaceRadius,
                        passedColor: widget.centerPassedColor,
                        remainingColor: widget.centerRemainingColor,
                      ),
                  ],
                ),
              ),
              if (widget.showTotalAmount == true)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Text(
                        R.string.total,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        widget.pieParameters
                            .fold(0.0, (p, e) => p + e.value)
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: indicatorSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getIndicators(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String title;
  final String? subtitle;
  final BoxShape? boxShape;
  final EdgeInsetsGeometry? padding;
  final void Function() changeSelectedIndex;
  final bool isSelected;
  final double indicatorSize;
  final double value;

  const _Indicator({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.boxShape,
    required this.padding,
    required this.changeSelectedIndex,
    required this.isSelected,
    required this.indicatorSize,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => changeSelectedIndex(),
      child: GestureDetector(
        onTap: changeSelectedIndex,
        child: Padding(
          padding: padding ?? const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: isSelected ? indicatorSize * 1.3 : indicatorSize,
                height: isSelected ? indicatorSize * 1.3 : indicatorSize,
                decoration: BoxDecoration(
                  shape: boxShape ?? BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      if (subtitle != null)
                        TextSpan(
                          text: "\n$subtitle",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieParameter {
  final double value;
  final String title;
  final String? subtitle;
  final Color? color;

  PieParameter({
    required this.value,
    required this.title,
    this.subtitle,
    this.color,
  });
}

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
  late DateTime _displayTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _setupClock();
  }

  @override
  void didUpdateWidget(covariant DayProgressClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date) {
      // Cancel the old timer before setting up a new one
      _timer?.cancel(); // <--- This line is crucial
      _setupClock();
    }
  }

  void _setupClock() {
    final now = DateTime.now();
    _isCurrentDay = widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;

    // Always cancel any existing timer before potentially creating a new one
    _timer?.cancel();
    _timer = null; // Clear the reference

    if (_isCurrentDay) {
      _displayTime = now;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        // Only call setState if the widget is still mounted
        if (mounted) {
          // <--- Added this check
          setState(() => _displayTime = DateTime.now());
        }
      });
    } else {
      _displayTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        23,
        59,
        59,
      );
      // No timer needed if it's not the current day
    }
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Ensure the timer is cancelled when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = 24 * 3600;
    final passedSeconds = _isCurrentDay
        ? _displayTime.hour * 3600 +
            _displayTime.minute * 60 +
            _displayTime.second
        : totalSeconds;
    final fraction = passedSeconds / totalSeconds;
    final timeString = DateFormat.Hm().format(_displayTime);

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
            timeString,
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

    // Draw the remaining background
    final paintRemaining = Paint()..color = remainingColor;
    canvas.drawCircle(center, radius, paintRemaining);

    // Draw the passed slice
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
