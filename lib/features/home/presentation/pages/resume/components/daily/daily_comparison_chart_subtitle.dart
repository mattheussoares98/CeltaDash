import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class DailyComparisonChartSubtitle extends StatelessWidget {
  const DailyComparisonChartSubtitle({
    super.key,
    required this.customers,
    required this.averageTicket,
  });

  final int customers;
  final double averageTicket;

  @override
  Widget build(BuildContext context) => BaseText.bodySmall(
    '${'Clientes'.hardcoded}: '
    '${customers.toString().toBrazilianNumber(0)}\n'
    '${'Média'.hardcoded}: '
    '${averageTicket.toString().toBrazilianNumber().addBrazilianCoin()}',
    fontStyle: FontStyle.italic,
  );
}
