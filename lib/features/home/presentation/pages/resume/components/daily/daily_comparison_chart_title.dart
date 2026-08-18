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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Sizes.p8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (date != null) BaseText.title(date!.formatDate(), color: color),
        BaseRichText(
          color: color,
          texts: [
            BaseText.title('R\$ '),
            BaseText.titleLarge(liquidValue.toString().toBRL()),
          ],
        ),
      ],
    ),
  );
}
