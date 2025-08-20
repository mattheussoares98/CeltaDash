import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import 'month_comparison.dart';

class MonthGoalComparison extends StatefulWidget {
  final bool isLoading;
  final ScrollController scrollController;
  const MonthGoalComparison({
    super.key,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  State<MonthGoalComparison> createState() => _MonthGoalComparisonState();
}

class _MonthGoalComparisonState extends State<MonthGoalComparison> {
  bool showEditGoal = false;
  final goalController = TextEditingController();
  final goalFocusNode = FocusNode();

  @override
  void dispose() {
    goalController.dispose();
    goalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resumePresenter = Get.find<ResumePresenter>();
    final homePresenter = Get.find<HomePresenter>();
    final mediaQuery = MediaQuery.of(context);

    return Obx(() {
      final sales = resumePresenter.monthlyComparison;

      final currentMonthSales = sales
          ?.filteredSales(
            enterprise: homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year,
          )
          .map((e) => e.toViewModel())
          .toList();

      final comparisonParams = resumePresenter.lastGetMonthlyComparisonParams;
      final comparisonSales = sales
          ?.filteredSales(
            enterprise: homePresenter.selectedEnterprise,
            filterYear: comparisonParams?.endDate.year,
            filterMonth: comparisonParams?.endDate.month,
          )
          .map((e) => e.toViewModel())
          .toList();
      final comparisonEndDate =
          resumePresenter.lastGetMonthlyComparisonParams?.endDate;

      final comparisonLiquidValue = comparisonSales?.sumLiquidValue() ?? 0;
      final currentMonthLiquidValue = currentMonthSales?.sumLiquidValue() ?? 0;
      final goalLiquidValue =
          resumePresenter.firebaseEnterpriseGoal?.value == null
              ? comparisonLiquidValue * 1.05
              : resumePresenter.firebaseEnterpriseGoal!.value!.toDouble();

      if (sales == null || sales.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: ContainerDecoration.defaultDecoration,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GoalTitle(
              comparisonEndDate: comparisonEndDate!,
              comparisonLiquidValue: comparisonLiquidValue,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: AnimatedCircleProgress(
                    key: ValueKey(goalLiquidValue),
                    value: currentMonthLiquidValue,
                    maximum: goalLiquidValue,
                    height: mediaQuery.size.width *
                        (mediaQuery.orientation == Orientation.portrait
                            ? 0.4
                            : 0.2),
                    width: mediaQuery.size.width *
                        (mediaQuery.orientation == Orientation.portrait
                            ? 0.4
                            : 0.2),
                    scrollController: widget.scrollController,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GoalValue(goalLiquidValue: goalLiquidValue),
                      const SizedBox(height: 8),
                      if (!showEditGoal)
                        EditGoalButton(changeShowEditGoal: () {
                          setState(() {
                            showEditGoal = !showEditGoal;
                          });
                          Future.delayed(Duration.zero, () {
                            goalFocusNode.requestFocus();
                          });
                        })
                      else
                        EditGoalFieldAndButtons(
                          goalController: goalController,
                          goalFocusNode: goalFocusNode,
                          changeShowEditGoal: () {
                            setState(() {
                              showEditGoal = !showEditGoal;
                            });
                          },
                        ),
                      const SizedBox(height: 8),
                      DefaultButton(
                        onTap: () {
                          //TODO implement
                        },
                        title: "Histórico",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
