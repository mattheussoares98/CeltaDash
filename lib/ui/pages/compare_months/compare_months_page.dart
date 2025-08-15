import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../main/utils/utils.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

bool _showAnimation = true;

class CompareMonthsPage extends StatefulWidget {
  const CompareMonthsPage({super.key});

  @override
  State<CompareMonthsPage> createState() => _CompareMonthsPageState();
}

class _CompareMonthsPageState extends State<CompareMonthsPage>
    with UIErrorManager {
  StreamSubscription? mainErrorSubscription;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final presenter = Get.find<CompareMonthsPresenter>();
        presenter.getSales();
        mainErrorSubscription = handleMainError(
            NavigatorKey.key.currentState!.context, presenter.mainErrorStream);
      }
    });
  }

  @override
  void dispose() {
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  int getDaysQuantity() {
    final presenter = Get.find<CompareMonthsPresenter>();
    final firstPeriodSales = presenter.firstMonthSales;
    final secondPeriodSales = presenter.secondMonthSales;

    final firstPeriodDaysQuantities =
        firstPeriodSales.map((sale) => sale.Date?.day).toSet().length;
    final secondPeriodDaysQuantities =
        secondPeriodSales.map((sale) => sale.Date?.day).toSet().length;

    return max(firstPeriodDaysQuantities, secondPeriodDaysQuantities);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final compareMonthsPresenter = Get.find<CompareMonthsPresenter>();
    final theme = Theme.of(context);

    return StreamBuilder(
        stream: compareMonthsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              showDatePicker: false,
              onChangeEnterprise: (_) {
                compareMonthsPresenter.getSales();
              },
              isLoading: loadingSnap.data,
            ),
            body: DefaultSafeArea(
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: ChangePeriod(
                            isLoading: loadingSnap.data == true,
                            title: R.string.firstPeriod,
                            month: compareMonthsPresenter.firstSelectedMonth,
                            year: compareMonthsPresenter.firstSelectedYear,
                            onMonthChanged: (month) {
                              setState(() {
                                compareMonthsPresenter
                                    .changeFirstSelectedMonth(month!);
                              });
                            },
                            onYearChanged: (year) {
                              setState(() {
                                compareMonthsPresenter
                                    .changeFirstSelectedYear(year!);
                              });
                            },
                          ),
                        ),
                        const VerticalDivider(
                          thickness: 0.3,
                          width: 0.3,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: ChangePeriod(
                            isLoading: loadingSnap.data == true,
                            title: R.string.secondPeriod,
                            month: compareMonthsPresenter.secondSelectedMonth,
                            year: compareMonthsPresenter.secondSelectedYear,
                            onMonthChanged: (month) {
                              setState(() {
                                compareMonthsPresenter
                                    .changeSecondSelectedMonth(month!);
                              });
                            },
                            onYearChanged: (year) {
                              setState(() {
                                compareMonthsPresenter
                                    .changeSecondSelectedYear(year!);
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: compareMonthsPresenter.getSales,
                          icon: loadingSnap.data == true
                              ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  theme.platform == TargetPlatform.iOS
                                      ? CupertinoIcons.refresh
                                      : Icons.refresh_outlined,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      final firstMonthSales =
                          compareMonthsPresenter.firstMonthSales;
                      final secondMonthSales =
                          compareMonthsPresenter.secondMonthSales;

                      if (firstMonthSales.isEmpty && secondMonthSales.isEmpty) {
                        return EmptySales(isLoading: loadingSnap.data == true);
                      }

                      return Column(
                        children: [
                          ScrollableTableItem(
                            titleMinHeight: isPortrait ? 40 : 25,
                            fixFirstColumn: true,
                            pdfFileName: R.string.compareMonths,
                            indexToSort: 0,
                            columnsIndexToSum: [1, 2, 3],
                            columnsWidths: [60, 80, 80, 80],
                            showAnimation: _showAnimation,
                            hideShowAnimation: () {
                              _showAnimation = false;
                            },
                            titles: [
                              PersonalizedTableCell(
                                value: R.string.day,
                                isTitle: true,
                              ),
                              PersonalizedTableCell(
                                value: DateFormat.yMMM('pt_BR').format(
                                  DateTime(
                                    compareMonthsPresenter
                                        .firstMonthParams!.startDate.year,
                                    compareMonthsPresenter
                                        .firstMonthParams!.startDate.month,
                                  ),
                                ),
                                isTitle: true,
                              ),
                              PersonalizedTableCell(
                                value: DateFormat.yMMM('pt_BR').format(
                                  DateTime(
                                    compareMonthsPresenter
                                        .secondMonthParams!.startDate.year,
                                    compareMonthsPresenter
                                        .secondMonthParams!.startDate.month,
                                  ),
                                ),
                                isTitle: true,
                              ),
                              PersonalizedTableCell(
                                value: R.string.difference,
                                isTitle: true,
                              ),
                            ],
                            rowValues:
                                List.generate(getDaysQuantity(), (index) {
                              final firstPeriodDaySales = firstMonthSales
                                  .filteredSales(filterDay: index + 1)
                                  .map((e) => e.toViewModel())
                                  .toList()
                                  .sumLiquidValue();

                              final secondPeriodDaySales = secondMonthSales
                                  .filteredSales(filterDay: index + 1)
                                  .map((e) => e.toViewModel())
                                  .toList()
                                  .sumLiquidValue();

                              double calculateDifference() {
                                if (secondPeriodDaySales == 0) {
                                  return firstPeriodDaySales > 0 ? 100.0 : 0.0;
                                } else if (firstPeriodDaySales == 0) {
                                  return -100.0;
                                }

                                return ((firstPeriodDaySales -
                                            secondPeriodDaySales) /
                                        secondPeriodDaySales) *
                                    100;
                              }

                              final difference = calculateDifference();

                              return [
                                PersonalizedTableCell(
                                  value: index + 1,
                                ),
                                PersonalizedTableCell(
                                  value: firstPeriodDaySales,
                                  isMoney: true,
                                ),
                                PersonalizedTableCell(
                                  value: secondPeriodDaySales,
                                  isMoney: true,
                                ),
                                PersonalizedTableCell(
                                  value: difference,
                                  isPercentage: true,
                                  decoration: BoxDecoration(
                                    color: difference > 0
                                        ? Colors.green.withOpacity(0.2)
                                        : difference < 0
                                            ? Colors.red.withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                              ];
                            }),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
