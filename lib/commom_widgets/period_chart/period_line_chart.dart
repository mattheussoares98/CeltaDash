import 'dart:math';

import 'package:celta_dash/commom_widgets/period_chart/period_line_chart_series.dart';
import 'package:celta_dash/commom_widgets/text/text.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PeriodLineChart extends StatelessWidget {
  const PeriodLineChart({
    required this.dates,
    required this.height,
    required this.series,
    this.title,
    this.minY,
    this.maxY,
    this.areaGradientTopAlpha = 150,
    this.tooltipTextBuilder,
    super.key,
  });

  final List<DateTime> dates;
  final double height;
  final List<PeriodLineChartSeries> series;
  final String? title;
  final double? minY;
  final double? maxY;
  final int areaGradientTopAlpha;
  final String Function(int index)? tooltipTextBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final minimumValue = series
        .expand((chartSeries) => chartSeries.values)
        .reduce(min);

    return Column(
      children: [
        if (title != null) ...[BaseText.title(title!), gapH4],
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              minY: minY ?? (minimumValue > 0 ? minimumValue / 1.1 : 0),
              maxY: maxY,
              lineBarsData: series
                  .map(
                    (chartSeries) => LineChartBarData(
                      spots: chartSeries.values.indexed
                          .map((entry) => FlSpot(entry.$1.toDouble(), entry.$2))
                          .toList(growable: false),
                      dotData: const FlDotData(show: false),
                      color: chartSeries.color,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            chartSeries.color.withAlpha(areaGradientTopAlpha),
                            chartSeries.color.withAlpha(10),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                  getTooltipItems: (spots) {
                    if (spots.isEmpty) return [];
                    final index = spots.first.x.toInt();
                    if (index < 0 || index >= dates.length) return [];
                    final tooltipText = tooltipTextBuilder?.call(index);
                    if (tooltipText != null) {
                      return [
                        LineTooltipItem(
                          tooltipText,
                          theme.textTheme.labelLarge!.copyWith(
                            color: theme.colorScheme.onInverseSurface,
                          ),
                        ),
                        ...spots.skip(1).map((_) => null),
                      ];
                    }
                    return spots.map((spot) {
                      final value = series[spot.barIndex].values[index];
                      return LineTooltipItem(
                        '${dates[index].formatDate()}\n'
                        '${value.toString().toBRL().addBrazilianCoin()}',
                        theme.textTheme.labelLarge!.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      );
                    }).toList();
                  },
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
                    interval: max(1, (dates.length / 8).ceil()).toDouble(),
                    reservedSize: Sizes.p32,
                    maxIncluded: false,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 ||
                          index >= dates.length ||
                          (value - index).abs() > 0.01) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Transform.rotate(
                          angle: -pi / 4,
                          child: BaseText.caption(
                            dates[index].formatDate(.ddMM),
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
