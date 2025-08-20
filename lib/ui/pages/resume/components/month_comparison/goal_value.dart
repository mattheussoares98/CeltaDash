import 'package:flutter/material.dart';

import '../../../../../ui/helpers/helpers.dart';

class GoalValue extends StatelessWidget {
  final double goalLiquidValue;
  const GoalValue({super.key, required this.goalLiquidValue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.black,
        ),
        text: "Meta",
        children: [
          TextSpan(
            text: " R\$",
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
          TextSpan(
            text: goalLiquidValue //TODO load goal from presenter
                .toString()
                .toBrazilianNumber(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
