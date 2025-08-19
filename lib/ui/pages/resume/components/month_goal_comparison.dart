import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class MonthGoalComparison extends StatefulWidget {
  final bool isLoading;
  const MonthGoalComparison({super.key, required this.isLoading});

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
      final sales = resumePresenter.monthlyComparison;

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

      final previousYearLiquidValue = previousYearSales?.sumLiquidValue();

      if (selectedYearSales == null || previousYearSales == null) {
        return EmptySales(isLoading: widget.isLoading);
      }

      return Container(
        decoration: ContainerDecoration.defaultDecoration,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              R.string.monthlyGoal.toUpperCase(),
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: AnimatedCircleProgress(
                    key: ValueKey(sales?.sumLiquidValue()),
                    value: selectedYearSales.sumLiquidValue(),
                    maximum: previousYearLiquidValue ?? 0,
                    height: mediaQuery.size.width *
                        (mediaQuery.orientation == Orientation.portrait
                            ? 0.4
                            : 0.2),
                    width: mediaQuery.size.width *
                        (mediaQuery.orientation == Orientation.portrait
                            ? 0.4
                            : 0.2),
                    scrollController: scrollController,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.orange,
                          ),
                          text:
                              "Base (${DateFormat.yM("pt_BR").format(DateTime(homePresenter.selectedDate.year - 1, homePresenter.selectedDate.month))}):",
                          children: [
                            TextSpan(
                              text: "\nR\$ ",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: Colors.orange,
                              ),
                            ),
                            TextSpan(
                                text: previousYearLiquidValue
                                    .toString()
                                    .toBrazilianNumber(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                )),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                          ),
                          text:
                              "Meta (base + 5%):", //TODO add option to change the goal and save in firebase
                          children: [
                            TextSpan(
                              text: "\nR\$ ",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 11, color: Colors.green),
                            ),
                            TextSpan(
                              text: ((previousYearLiquidValue ?? 0) *
                                      1.05) //TODO use the goal here
                                  .toString()
                                  .toBrazilianNumber(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          //TODO implement
                        },
                        icon: Icon(
                          theme.platform == TargetPlatform.iOS
                              ? CupertinoIcons.pencil
                              : Icons.edit,
                        ),
                        label: const Text("Editar meta"),
                      ),
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
