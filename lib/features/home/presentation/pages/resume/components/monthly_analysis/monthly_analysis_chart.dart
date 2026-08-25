import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyAnalysisChart extends StatelessWidget {
  const MonthlyAnalysisChart({super.key, required this.days});

  final List<MonthlyAnalysisDayState> days;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final values = days.map((day) => day.value);
    final minValue = values.reduce(min);
    final chartHeight = MediaQuery.heightOf(context) * 0.33;

    return Column(
      children: [
        BaseText.title(
          '${days.first.date.formatDate()} ~ ${days.last.date.formatDate()}',
        ),
        gapH4,
        SizedBox(
          height: chartHeight,
          child: LineChart(
            LineChartData(
              minY: minValue > 0 ? minValue / 1.1 : 0,
              lineBarsData: [
                LineChartBarData(
                  spots: days.indexed
                      .map(
                        (entry) => FlSpot(entry.$1.toDouble(), entry.$2.value),
                      )
                      .toList(),
                  dotData: const FlDotData(show: false),
                  color: theme.primaryColor,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor.withAlpha(150),
                        theme.primaryColor.withAlpha(10),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                  getTooltipItems: (spots) => spots.map((spot) {
                    final day = days[spot.x.toInt()];
                    return LineTooltipItem(
                      '${day.date.formatDate()}\n'
                      '${day.value.toString().toBRL().addBrazilianCoin()}',
                      theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.onInverseSurface,
                      ),
                    );
                  }).toList(),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: Sizes.p32,
                    minIncluded: false,
                    maxIncluded: false,
                    getTitlesWidget: (value, _) =>
                        BaseText.caption(_compactValue(value)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: max(1, (days.length / 8).ceil()).toDouble(),
                    reservedSize: Sizes.p32,
                    maxIncluded: false,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 ||
                          index >= days.length ||
                          (value - index).abs() > 0.01) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Transform.rotate(
                          angle: -pi / 4,
                          child: BaseText.caption(
                            days[index].date.formatDate(.ddMM),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _compactValue(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toString().toBRL(1)}M';
    }
    if (value.abs() >= 1000) {
      return '${(value / 1000).toString().toBRL(0)}K';
    }
    return value.toString().toBRL(0);
  }
}
