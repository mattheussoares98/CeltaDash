import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/helpers.dart';

class GoalTitle extends StatelessWidget {
  final DateTime comparisonEndDate;
  final double comparisonLiquidValue;
  const GoalTitle({
    super.key,
    required this.comparisonEndDate,
    required this.comparisonLiquidValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            R.string.monthlyGoal.toUpperCase(),
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Tooltip(
            message:
                '''Meta = vendas de (${DateFormat.yM("pt_BR").format(DateTime(comparisonEndDate.year, comparisonEndDate.month))}) + 5% 
'${comparisonLiquidValue.toString().toBrazilianNumber().addBrazilianCoin()}' + 5%''',
            child: Icon(
              theme.platform == TargetPlatform.iOS
                  ? CupertinoIcons.info
                  : Icons.info_outline_rounded,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
