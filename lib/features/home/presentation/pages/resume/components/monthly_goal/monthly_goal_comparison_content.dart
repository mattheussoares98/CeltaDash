import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class MonthlyGoalComparisonContent extends StatelessWidget {
  const MonthlyGoalComparisonContent({super.key, required this.comparison});

  final MonthlyGoalComparisonState comparison;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final circleSize = min(
            (constraints.maxWidth - Sizes.p16) / 2,
            Sizes.p120,
          );
          return Row(
            children: [
              Expanded(
                child: AnimatedCircleProgress(
                  key: ValueKey(
                    comparison.currentMonthLiquidValue + comparison.monthlyGoal,
                  ),
                  title: 'Meta mensal'.hardcoded,
                  value: comparison.currentMonthLiquidValue.toDouble(),
                  maximum: comparison.monthlyGoal,
                  height: circleSize,
                  width: circleSize,
                ),
              ),
              gapW16,
              Expanded(
                child: AnimatedCircleProgress(
                  key: ValueKey(
                    comparison.selectedDayLiquidValue + comparison.dailyGoal,
                  ),
                  title: 'Meta diária'.hardcoded,
                  value: comparison.selectedDayLiquidValue.toDouble(),
                  maximum: comparison.dailyGoal,
                  height: circleSize,
                  width: circleSize,
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
