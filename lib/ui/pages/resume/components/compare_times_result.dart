import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';

class CompareTimesResult extends StatelessWidget {
  final String betterTime;
  final String worstTime;
  final double betterValue;
  final double worstValue;
  const CompareTimesResult({
    super.key,
    required this.betterTime,
    required this.worstTime,
    required this.betterValue,
    required this.worstValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Item(isBestHour: true, hour: betterTime, value: betterValue),
        _Item(isBestHour: false, hour: betterTime, value: worstValue),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.isBestHour,
    required this.hour,
    required this.value,
  });

  final bool isBestHour;
  final String hour;
  final double value;

  @override
  Widget build(BuildContext context) {
    final color = isBestHour ? Colors.green : Colors.red;
    return Expanded(
      child: Column(
        children: [
          Text(
            isBestHour ? "Best hour" : "Worst hour",
            style: TextStyle(color: color),
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isBestHour
                      ? Icons.sentiment_satisfied_alt
                      : Icons.sentiment_dissatisfied_rounded,
                  color: color,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FittedBox(
                    child: Text(hour, style: TextStyle(color: color)),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value.toString().toBrazilianNumber().addBrazilianCoin(),
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
