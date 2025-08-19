import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool showEditGoal = false;
  final goalController = TextEditingController();
  final goalFocusNode = FocusNode();

  @override
  void dispose() {
    scrollController.dispose();
    goalController.dispose();
    goalFocusNode.dispose();
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
      final goalLiquidValue = comparisonLiquidValue * 1.05;

      if (sales == null || sales.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: ContainerDecoration.defaultDecoration,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
                        '''Meta = vendas de (${DateFormat.yM("pt_BR").format(DateTime(comparisonEndDate!.year, comparisonEndDate.month))}) + 5% 
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
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: AnimatedCircleProgress(
                    key: ValueKey(sales.sumLiquidValue()),
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
                    scrollController: scrollController,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                          text: "Meta",
                          children: [
                            TextSpan(
                              text: " R\$",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 11),
                            ),
                            TextSpan(
                              text:
                                  goalLiquidValue //TODO load goal from presenter
                                      .toString()
                                      .toBrazilianNumber(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!showEditGoal)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showEditGoal = !showEditGoal;
                            });
                            Future.delayed(Duration.zero, () {
                              goalFocusNode.requestFocus();
                            });
                          },
                          icon: Icon(
                            theme.platform == TargetPlatform.iOS
                                ? CupertinoIcons.pencil
                                : Icons.edit,
                          ),
                          label: const Text("Editar meta"),
                        )
                      else
                        Column(
                          children: [
                            TextFormField(
                              focusNode: goalFocusNode,
                              controller: goalController,
                              decoration: FormFieldDecoration.decoration(
                                context: context,
                                labelText: R.string.goal.addBrazilianCoin(),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                BrazilianRealInputFormatter(),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showEditGoal = !showEditGoal;
                                    });
                                  },
                                  child: Icon(
                                    theme.platform == TargetPlatform.iOS
                                        ? CupertinoIcons.xmark
                                        : Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    //TODO call presenter to change remotelly
                                  },
                                  child: Icon(
                                    theme.platform == TargetPlatform.iOS
                                        ? CupertinoIcons.check_mark
                                        : Icons.save,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
