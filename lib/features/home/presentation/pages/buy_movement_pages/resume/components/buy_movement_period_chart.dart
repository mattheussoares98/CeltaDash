import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BuyMovementPeriodChart extends StatelessWidget {
  const BuyMovementPeriodChart({required this.rows, super.key});

  final List<BuyMovementDataRowEntity> rows;

  @override
  Widget build(BuildContext context) {
    final datedRows = rows.where((row) => row.date != null).toList()
      ..sort((a, b) => a.date!.compareTo(b.date!));
    if (datedRows.isEmpty) {
      return Center(child: BaseText('Nenhuma compra encontrada'.hardcoded));
    }
    final maxValue = datedRows
        .map((row) => row.totalValue.toDouble())
        .reduce(max);
    final color = context.theme.primaryColor;

    return SizedBox(
      height: MediaQuery.heightOf(context) * 0.28,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxValue > 0 ? maxValue * 1.15 : 100,
          lineBarsData: [
            LineChartBarData(
              spots: datedRows.indexed
                  .map(
                    (entry) => FlSpot(
                      entry.$1.toDouble(),
                      entry.$2.totalValue.toDouble(),
                    ),
                  )
                  .toList(growable: false),
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: color.withAlpha(35)),
            ),
          ],
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
