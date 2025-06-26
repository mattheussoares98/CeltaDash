import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../main/utils/utils.dart';
import '../../helpers/helpers.dart';
import 'chart_pie.dart';

// A pie chart widget that can optionally show a day-progress clock in its center hole.
class ChartPieWidget extends StatefulWidget {
  final List<PieParameter> pieParameters;
  final int? quantityToShow;
  final BoxShape? itemsShape;
  final EdgeInsetsGeometry? paddingItems;
  final bool? showTotalAmount;

  // Date for the clock: if null, no clock; if not today's date, shows completed.
  final DateTime? centerDate;
  // Color for the passed slice in the clock.
  final Color centerPassedColor;
  // Color for the remaining slice in the clock.
  final Color centerRemainingColor;

  const ChartPieWidget({
    super.key,
    required this.pieParameters,
    this.itemsShape = BoxShape.circle,
    this.quantityToShow,
    this.paddingItems,
    this.showTotalAmount = true,
    this.centerDate,
    this.centerPassedColor = Colors.blue,
    this.centerRemainingColor = const Color(0xFFE0E0E0),
  });

  @override
  State<ChartPieWidget> createState() => _ChartPieWidgetState();
}

class _ChartPieWidgetState extends State<ChartPieWidget> {
  int? selectedIndex;

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
    if (total == 0) total = 0.001;
    return List.generate(
      widget.pieParameters.length,
      (i) {
        if (needBreakLoop(i)) return null;
        final param = widget.pieParameters[i];
        final isTouched = i == selectedIndex;
        final radius = chartWidth * (isTouched ? 0.23 : 0.2);
        return PieChartSectionData(
          color: param.color ?? colors[i],
          value: (param.value == 0 && i == 1) ? 0.01 : param.value,
          title:
              '${(param.value / total * 100).toString().toBrazilianNumber(0)}%',
          radius: radius,
          titleStyle: Theme.of(context).textTheme.titleSmall,
        );
      },
    ).whereType<PieChartSectionData>().toList();
  }

  void changeSelectedIndex(int? index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  List<Indicator> getIndicators(double indicatorSize) {
    return List.generate(
      widget.pieParameters.length,
      (i) {
        if (needBreakLoop(i)) return null;
        final param = widget.pieParameters[i];
        return Indicator(
          title: param.title,
          subtitle: param.subtitle,
          showOnlyOnTap: param.showSubtitleOnlyOnTap,
          value: param.value,
          color: param.color ?? colors[i],
          boxShape: widget.itemsShape!,
          padding: widget.paddingItems,
          isSelected: i == selectedIndex,
          indicatorSize: indicatorSize,
          changeSelectedIndex: () {
            changeSelectedIndex(i);
          },
        );
      },
    ).whereType<Indicator>().toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(NavigatorKey.key.currentState!.context).size.width;
    double chartWidth = screenWidth * 0.4;
    double indicatorSize = screenWidth * 0.04;
    double chartPadding = screenWidth * 0.01;
    double centerSpaceRadius = screenWidth * 0.1;

    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: chartWidth,
              height: chartWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, PieTouchResponse? resp) {
                          // Only act once on tap up
                          if (event is FlTapUpEvent) {
                            final idx =
                                resp?.touchedSection?.touchedSectionIndex;
                            if (idx != null && idx >= 0) {
                              changeSelectedIndex(idx);
                            } else {
                              changeSelectedIndex(null);
                            }
                          }
                        },
                      ),
                      borderData: null,
                      sectionsSpace: 3,
                      centerSpaceRadius: centerSpaceRadius,
                      centerSpaceColor: Colors.transparent,
                      sections: getSections(chartWidth),
                      startDegreeOffset: 180,
                    ),
                  ),
                  if (widget.centerDate != null)
                    DayProgressClock(
                      date: widget.centerDate!,
                      radius: centerSpaceRadius,
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
            padding: EdgeInsets.only(left: chartPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getIndicators(indicatorSize),
            ),
          ),
        ),
      ],
    );
  }
}
