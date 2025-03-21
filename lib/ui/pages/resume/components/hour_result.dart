import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';

class HourResult extends StatelessWidget {
  final String hour;
  final bool isBestHour;
  final double value;
  const HourResult({
    super.key,
    required this.hour,
    required this.isBestHour,
    required this.value,
  });

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
