import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class DailyComparisonChartTitle extends StatelessWidget {
  const DailyComparisonChartTitle({
    super.key,
    required this.liquidValue,
    required this.color,
    this.date,
  });

  final num liquidValue;
  final Color color;
  final DateTime? date;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (date != null) BaseText.titleLarge(date!.formatDate(), color: color),
      BaseText.titleLarge(
        liquidValue.toString().toBrazilianNumber().addBrazilianCoin(),
        color: color,
      ),
    ],
  );
}
