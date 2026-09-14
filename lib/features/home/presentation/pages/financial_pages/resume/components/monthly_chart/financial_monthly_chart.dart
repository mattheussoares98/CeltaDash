import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
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
            BaseText('A receber'.hardcoded),
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
            BaseText('A pagar'.hardcoded),
          ],
        ),
        gapH8,
        PeriodLineChart(
          dates: days.map((day) => day.date).toList(growable: false),
          height: chartHeight,
          series: [
            PeriodLineChartSeries(
              values: days
                  .map((day) => day.receiveValue)
                  .toList(growable: false),
              color: receiveColor,
            ),
            PeriodLineChartSeries(
              values: days.map((day) => day.payValue).toList(growable: false),
              color: payColor,
            ),
          ],
          minY: 0,
          maxY: maxValue > 0 ? maxValue * 1.15 : 100,
          areaGradientTopAlpha: 100,
          tooltipTextBuilder: (index) {
            final day = days[index];
            return '${day.date.formatDate()}\n'
                '${'Receber: '.hardcoded}${day.receiveValue.toString().toBRL().addBrazilianCoin()}\n'
                '${'Pagar: '.hardcoded}${day.payValue.toString().toBRL().addBrazilianCoin()}';
          },
        ),
      ],
    );
  }
}
