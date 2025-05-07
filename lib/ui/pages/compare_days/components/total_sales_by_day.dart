import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/helpers.dart';

class TotalSalesByDay extends StatelessWidget {
  final DateTime date;
  final double totalSales;
  const TotalSalesByDay({
    super.key,
    required this.date,
    required this.totalSales,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text(
            "${R.string.total} ${DateFormat.yMd('pt_BR').format(date)}",
          ),
        ),
        FittedBox(
          child: Text(
            totalSales.toString().toBrazilianNumber().addBrazilianCoin(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
