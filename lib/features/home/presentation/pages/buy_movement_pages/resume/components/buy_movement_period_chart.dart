import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
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
    final values = datedRows
        .map((row) => row.totalValue.toDouble())
        .toList(growable: false);
    final maxValue = values.reduce(max);

    return PeriodLineChart(
      dates: datedRows.map((row) => row.date!).toList(growable: false),
      height: MediaQuery.heightOf(context) * 0.28,
      series: [
        PeriodLineChartSeries(
          values: values,
          color: context.theme.primaryColor,
        ),
      ],
      minY: 0,
      maxY: maxValue > 0 ? maxValue * 1.15 : 100,
    );
  }
}
