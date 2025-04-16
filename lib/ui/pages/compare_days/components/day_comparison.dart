import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/helpers.dart';

class DayComparison extends StatelessWidget {
  final DateTime firstDate;
  final DateTime secondDate;
  final double totalDifference;
  final double totalFirstDay;
  final double totalSecondDay;
  const DayComparison({
    super.key,
    required this.firstDate,
    required this.secondDate,
    required this.totalDifference,
    required this.totalFirstDay,
    required this.totalSecondDay,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "${R.string.day} ${DateFormat.yMd("pt_BR").format(firstDate)} ",
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(text: R.string.sold.toLowerCase()),
          TextSpan(
            text: " ${totalDifference.toString().toBrazilianNumber()}% ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: totalFirstDay > totalSecondDay ? Colors.green : Colors.red,
            ),
          ),
          TextSpan(text: R.string.comparedToDay.toLowerCase()),
          TextSpan(text: " ${DateFormat.yMd("pt_BR").format(secondDate)}"),
        ],
      ),
    );
  }
}
