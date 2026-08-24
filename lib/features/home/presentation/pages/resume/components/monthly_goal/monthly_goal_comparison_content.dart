import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonthlyGoalComparisonContent extends ConsumerWidget {
  const MonthlyGoalComparisonContent({
    super.key,
    required this.comparison,
    required this.enterpriseId,
  });

  final MonthlyGoalComparisonState comparison;
  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedGoal = ref.watch(
      monthlyGoalsControllerProvider.select(
        (goals) =>
            goals.value?[MonthlyGoalKey(
              enterpriseId: enterpriseId,
              year: comparison.selectedDate.year,
              month: comparison.selectedDate.month,
            )],
      ),
    );
    final displayedComparison = comparison.copyWith(
      customMonthlyGoal: cachedGoal?.value,
      customMonthlyGoalAuthor: cachedGoal?.userName,
    );

    return Stack(
      children: [
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final circleSize = min(
                      (constraints.maxWidth - Sizes.p16) / 2,
                      Sizes.p120,
                    );
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedCircleProgress(
                                key: ValueKey(
                                  displayedComparison.currentMonthLiquidValue +
                                      displayedComparison.monthlyGoal,
                                ),
                                title: 'Meta mensal'.hardcoded,
                                value: displayedComparison
                                    .currentMonthLiquidValue
                                    .toDouble(),
                                maximum: displayedComparison.monthlyGoal,
                                height: circleSize,
                                width: circleSize,
                              ),
                            ),
                            gapW16,
                            Expanded(
                              child: AnimatedCircleProgress(
                                key: ValueKey(
                                  displayedComparison.selectedDayLiquidValue +
                                      displayedComparison.dailyGoal,
                                ),
                                title: 'Meta diária'.hardcoded,
                                value: displayedComparison
                                    .selectedDayLiquidValue
                                    .toDouble(),
                                maximum: displayedComparison.dailyGoal,
                                height: circleSize,
                                width: circleSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              MonthlyGoalEditor(enterpriseId: enterpriseId),
              gapH8,
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: MonthlyGoalInfoButton(
            comparison: displayedComparison,
            cachedGoal: cachedGoal,
          ),
        ),
      ],
    );
  }
}
