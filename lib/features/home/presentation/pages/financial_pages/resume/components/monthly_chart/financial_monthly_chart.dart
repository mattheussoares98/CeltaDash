// lib/features/home/presentation/pages/financial/resume/components/monthly_chart/financial_monthly_chart.dart
import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FinancialMonthlyChart extends StatelessWidget {
  const FinancialMonthlyChart({super.key, required this.days});

  final List<FinancialMonthlyAnalysisDayState> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Center(
        child: BaseText('Nenhum dado encontrado no período'.hardcoded),
      );
    }

    final theme = context.theme;
    final receiveColor = theme.primaryColor;
    const payColor = Colors.amber;

    final allValues = days.expand((d) => [d.receiveValue, d.payValue]);
    final maxValue = allValues.isEmpty ? 0.0 : allValues.reduce(max);
    final chartHeight = MediaQuery.heightOf(context) * 0.33;

    return Column(
      children: [
        BaseText.title(
          '${days.first.date.formatDate()} ~ ${days.last.date.formatDate()}',
        ),
        gapH8,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: receiveColor,
                shape: BoxShape.circle,
              ),
            ),
            gapW4,
            BaseText.caption('A receber'.hardcoded),
            gapW16,
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: payColor,
                shape: BoxShape.circle,
              ),
            ),
            gapW4,
            BaseText.caption('A pagar'.hardcoded),
          ],
        ),
        gapH8,
        SizedBox(
          height: chartHeight,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxValue > 0 ? maxValue * 1.15 : 100,
              lineBarsData: [
                LineChartBarData(
                  spots: days.indexed
                      .map(
                        (entry) =>
                            FlSpot(entry.$1.toDouble(), entry.$2.receiveValue),
                      )
                      .toList(),
                  dotData: const FlDotData(show: false),
                  color: receiveColor,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        receiveColor.withAlpha(100),
                        receiveColor.withAlpha(10),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: days.indexed
                      .map(
                        (entry) =>
                            FlSpot(entry.$1.toDouble(), entry.$2.payValue),
                      )
                      .toList(),
                  dotData: const FlDotData(show: false),
                  color: payColor,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        payColor.withAlpha(100),
                        payColor.withAlpha(10),
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
                  getTooltipItems: (spots) {
                    if (spots.isEmpty) return [];
                    final index = spots.first.x.toInt();
                    if (index < 0 || index >= days.length) return [];
                    final day = days[index];

                    return [
                      LineTooltipItem(
                        '${day.date.formatDate()}\n'
                        '${'Receber: '.hardcoded}${day.receiveValue.toString().toBRL().addBrazilianCoin()}\n'
                        '${'Pagar: '.hardcoded}${day.payValue.toString().toBRL().addBrazilianCoin()}',
                        theme.textTheme.labelLarge!.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                      null,
                    ];
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
