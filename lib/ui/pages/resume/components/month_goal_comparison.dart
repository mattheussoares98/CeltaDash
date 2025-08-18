import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class MonthGoalComparison extends StatefulWidget {
  const MonthGoalComparison({super.key});

  @override
  State<MonthGoalComparison> createState() => _MonthGoalComparisonState();
}

class _MonthGoalComparisonState extends State<MonthGoalComparison> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resumePresenter = Get.find<ResumePresenter>();
    final homePresenter = Get.find<HomePresenter>();
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Obx(() {
      final sales =
          resumePresenter.compareCurrentAndPreviousYearMonthStatistics;

      final selectedYearSales = sales
          ?.filteredSales(
            enterprise: homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year,
          )
          .map((e) => e.toViewModel())
          .toList();
      final previousYearSales = sales
          ?.filteredSales(
            enterprise: homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year - 1,
          )
          .map((e) => e.toViewModel())
          .toList();

      if (selectedYearSales == null || previousYearSales == null) {
        return const EmptySales(isLoading: false);
      }

      return Container(
        decoration: ContainerDecoration.defaultDecoration,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  R.string.goal.toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                )
              ],
            ),
            const SizedBox(height: 16),
            AnimatedCircleProgress(
              value: selectedYearSales.sumLiquidValue(),
              maximum: previousYearSales.sumLiquidValue(),
              height: mediaQuery.size.width *
                  (mediaQuery.orientation == Orientation.portrait ? 0.4 : 0.2),
              width: mediaQuery.size.width *
                  (mediaQuery.orientation == Orientation.portrait ? 0.4 : 0.2),
              scrollController: scrollController,
            ),
          ],
        ),
      );
    });
  }
}
