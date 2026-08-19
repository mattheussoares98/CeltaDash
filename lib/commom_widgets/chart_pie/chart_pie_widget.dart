import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_utils/get_utils.dart';

const _kColors = [
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

// A pie chart widget that can optionally show a day-progress clock in its center hole.
class ChartPieWidget extends HookWidget {
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
  final int leftFlex;
  final int rightFlex;

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
    this.leftFlex = 2,
    this.rightFlex = 2,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int?>(null);

    // Granular subscriptions — only rebuilds when size/orientation actually change.
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final chartWidth = min(height * 0.23, width * 0.45);
    const indicatorSize = Sizes.p12;
    final centerSpaceRadius = chartWidth * 0.25;
    final maxIndex = quantityToShow ?? 4;

    void onChangeSelected(int? index) {
      selectedIndex.value = selectedIndex.value == index ? null : index;
    }

    final sections = useMemoized(
      () => _buildSections(
        pieParameters: pieParameters,
        maxIndex: maxIndex,
        selectedIndex: selectedIndex.value,
        chartWidth: chartWidth,
        textStyle: context.textTheme.titleSmall,
      ),
      [pieParameters, maxIndex, selectedIndex.value, chartWidth],
    );

    final indicators = useMemoized(
      () => _buildIndicators(
        pieParameters: pieParameters,
        maxIndex: maxIndex,
        selectedIndex: selectedIndex.value,
        indicatorSize: indicatorSize,
        itemsShape: itemsShape!,
        padding: paddingItems,
        onChangeSelected: onChangeSelected,
      ),
      [
        pieParameters,
        maxIndex,
        selectedIndex.value,
        indicatorSize,
        itemsShape,
        paddingItems,
      ],
    );

    final indicatorsColumn = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: indicators,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: leftFlex,
          child: Column(
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
                                if (event is FlTapUpEvent) {
                                  final idx =
                                      resp?.touchedSection?.touchedSectionIndex;
                                  if (idx != null && idx >= 0) {
                                    onChangeSelected(idx);
                                  } else {
                                    onChangeSelected(null);
                                  }
                                }
                              },
                        ),
                        sectionsSpace: 3,
                        centerSpaceRadius: centerSpaceRadius,
                        centerSpaceColor: Colors.transparent,
                        sections: sections,
                        startDegreeOffset: 180,
                      ),
                    ),
                    if (centerDate != null)
                      DayProgressClock(
                        date: centerDate!,
                        radius: centerSpaceRadius,
                        passedColor: centerPassedColor,
                        remainingColor: centerRemainingColor,
                      ),
                  ],
                ),
              ),
              if (showTotalAmount == true)
                BaseRichText(
                  textAlign: .center,
                  texts: [
                    BaseText.caption('R\$ ', fontWeight: .bold),
                    BaseText.title(
                      pieParameters
                          .fold(0.0, (p, e) => p + e.value)
                          .toString()
                          .toBRL(),
                    ),
                  ],
                ),
            ],
          ),
        ),
        gapW12,
        if (isPortrait)
          Expanded(
            flex: rightFlex,
            child: Padding(
              padding: const EdgeInsets.only(),
              child: indicatorsColumn,
            ),
          ),
        if (!isPortrait)
          Flexible(
            flex: rightFlex,
            child: Padding(
              padding: const EdgeInsets.only(),
              child: indicatorsColumn,
            ),
          ),
      ],
    );
  }
}

// ── Pure helper functions (no widget dependency, easily testable) ──

bool _needBreakLoop(int index, int maxIndex) =>
    index > maxIndex || (index + 1) > _kColors.length;

List<PieChartSectionData> _buildSections({
  required List<PieParameter> pieParameters,
  required int maxIndex,
  required int? selectedIndex,
  required double chartWidth,
  required TextStyle? textStyle,
}) {
  double total = pieParameters.fold<double>(0, (p, e) => p + e.value);
  if (total == 0) total = 0.001;

  return List.generate(pieParameters.length, (i) {
    if (_needBreakLoop(i, maxIndex)) return null;
    final param = pieParameters[i];
    final isTouched = i == selectedIndex;
    final radius = chartWidth * (isTouched ? 0.23 : 0.2);
    return PieChartSectionData(
      color: param.color ?? _kColors[i],
      value: (param.value == 0 && i == 1) ? 0.01 : param.value,
      title: '${(param.value / total * 100).toString().toBRL(0)}%',
      radius: radius,
      titleStyle: textStyle,
    );
  }).whereType<PieChartSectionData>().toList();
}

List<Indicator> _buildIndicators({
  required List<PieParameter> pieParameters,
  required int maxIndex,
  required int? selectedIndex,
  required double indicatorSize,
  required BoxShape itemsShape,
  required EdgeInsetsGeometry? padding,
  required void Function(int?) onChangeSelected,
}) {
  return List.generate(pieParameters.length, (i) {
    if (_needBreakLoop(i, maxIndex)) return null;
    final param = pieParameters[i];
    return Indicator(
      title: param.title,
      subtitle: param.subtitle,
      showOnlyOnTap: param.showSubtitleOnlyOnTap,
      value: param.value,
      color: param.color ?? _kColors[i],
      boxShape: itemsShape,
      padding: padding,
      isSelected: i == selectedIndex,
      indicatorSize: indicatorSize,
      changeSelectedIndex: () => onChangeSelected(i),
    );
  }).whereType<Indicator>().toList();
}
