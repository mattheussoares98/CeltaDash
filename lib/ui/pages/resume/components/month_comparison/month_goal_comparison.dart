import 'dart:math';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
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

  double getCircleSize(MediaQueryData mediaQuery) {
    final value =
        mediaQuery.size.width *
        (mediaQuery.orientation == Orientation.portrait ? 0.4 : 0.2);

    return min(value, 130);
  }

  @override
  Widget build(BuildContext context) {
    final resumePresenter = Get.find<ResumePresenter>();
    final homePresenter = Get.find<HomePresenter>();
    final mediaQuery = MediaQuery.of(context);
    final circleSize = getCircleSize(mediaQuery);

    return Obx(() {
      final sales = resumePresenter.monthlyComparison;

      final currentMonthLiquidValue =
          sales
              ?.filteredSales(
                enterprise: homePresenter.selectedEnterprise,
                filterYear: homePresenter.selectedDate.year,
                filterMonth: homePresenter.selectedDate.month,
              )
              .map((e) => e.toViewModel())
              .toList()
              .sumLiquidValue() ??
          0;

      final comparisonLiquidValue =
          sales
              ?.filteredSales(
                enterprise: homePresenter.selectedEnterprise,
                filterYear: resumePresenter
                    .lastGetMonthlyComparisonParams
                    ?.endDate
                    .year,
                filterMonth: resumePresenter
                    .lastGetMonthlyComparisonParams
                    ?.endDate
                    .month,
              )
              .map((e) => e.toViewModel())
              .toList()
              .sumLiquidValue() ??
          0;

      final goalLiquidValue =
          resumePresenter.firebaseEnterpriseGoal?.value == null
          ? comparisonLiquidValue * 1.05
          : resumePresenter.firebaseEnterpriseGoal!.value!.toDouble();

      final salesTodayLiquidValue =
          resumePresenter.saleStatistics
              ?.filteredSales(
                enterprise: homePresenter.selectedEnterprise,
                filterYear: homePresenter.selectedDate.year,
                filterMonth: homePresenter.selectedDate.month,
                filterDay: homePresenter.selectedDate.day,
              )
              .map((e) => e.toViewModel())
              .toList()
              .sumLiquidValue() ??
          0;

      final comparisonEndDate =
          resumePresenter.lastGetMonthlyComparisonParams?.endDate;

      if (sales == null || sales.isEmpty) {
        return const SizedBox.shrink();
      }

      final daysInMonth =
          resumePresenter.firebaseEnterpriseGoal?.value == null &&
              comparisonEndDate != null
          ? DateTime(comparisonEndDate.year, comparisonEndDate.month + 1, 0).day
          : DateTime(
              homePresenter.selectedDate.year,
              homePresenter.selectedDate.month + 1,
              0,
            ).day;

      return Stack(
        children: [
          Container(
            decoration: ContainerDecoration.defaultDecoration,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AnimatedCircleProgress(
                        key: ValueKey(comparisonLiquidValue + goalLiquidValue!),
                        title: R.string.monthlyGoal,
                        value: currentMonthLiquidValue,
                        maximum: goalLiquidValue,
                        height: circleSize,
                        width: circleSize,
                      ),
                    ),
                    Expanded(
                      child: AnimatedCircleProgress(
                        key: ValueKey(salesTodayLiquidValue + goalLiquidValue),
                        title: R.string.dailyGoal,
                        value: salesTodayLiquidValue,
                        maximum: goalLiquidValue / daysInMonth,
                        height: circleSize,
                        width: circleSize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!showEditGoal)
                      Expanded(
                        child: EditGoalButton(
                          changeShowEditGoal: () {
                            setState(() {
                              showEditGoal = !showEditGoal;
                            });
                            Future.delayed(Duration.zero, () {
                              goalFocusNode.requestFocus();
                            });
                            goalController.clear();
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: EditGoalFieldAndButtons(
                          goalController: goalController,
                          goalFocusNode: goalFocusNode,
                          changeShowEditGoal: () {
                            setState(() {
                              showEditGoal = !showEditGoal;
                            });
                            goalController.clear();
                          },
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DefaultButton(
                        onTap: resumePresenter.goToGoalHistoricPage,
                        title: R.string.historic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GoalInfoButton(
              comparisonEndDate: comparisonEndDate!,
              comparisonLiquidValue: comparisonLiquidValue,
              goalLiquidValue: goalLiquidValue,
            ),
          ),
        ],
      );
    });
  }
}
