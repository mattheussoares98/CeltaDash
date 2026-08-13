import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class OperatorsPage extends StatefulWidget {
  const OperatorsPage({super.key});

  @override
  State<OperatorsPage> createState() => _OperatorsPageState();
}

class _OperatorsPageState extends State<OperatorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OperatorsPresenter operatorsPresenter = Get.find();

      operatorsPresenter.getSales();
    });
  }

  List<SaleStatisticViewModel>? getSales({
    required List<SaleStatisticViewModel>? dailyStatistics,
    required List<SaleStatisticViewModel>? monthlyStatistics,
    required List<SaleStatisticViewModel>? yearlyStatistics,
    required OperatorsPresenter operatorsPresenter,
  }) {
    if (operatorsPresenter.selectedPeriod == PeriodType.daily) {
      return dailyStatistics;
    } else if (operatorsPresenter.selectedPeriod == PeriodType.monthly) {
      return monthlyStatistics;
    } else if (operatorsPresenter.selectedPeriod == PeriodType.yearly) {
      return yearlyStatistics;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    OperatorsPresenter operatorsPresenter = Get.find();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return StreamBuilder(
        stream: operatorsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            body: DefaultSafeArea(
              child: Column(
                children: [
                  DefaultAppBar(
                    isLoading: loadingSnap.data == true,
                    onChangeEnterprise: (_) {
                      operatorsPresenter.getSales();
                    },
                    onChangeDate: (_) {
                      operatorsPresenter.getSales();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(isPortrait ? 8.0 : 0),
                    child: SelectPeriodItems(
                      isLoading: loadingSnap.data,
                      selectedPeriodType: operatorsPresenter.selectedPeriod,
                      onTapDaily: () {
                        operatorsPresenter.getSales(
                          periodType: PeriodType.daily,
                        );
                      },
                      onTapMonthly: () {
                        operatorsPresenter.getSales(
                          periodType: PeriodType.monthly,
                        );
                      },
                      onTapYearly: () {
                        operatorsPresenter.getSales(
                          periodType: PeriodType.yearly,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final dailyStatistics = operatorsPresenter.dailyStatistics
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                            filterYear: homePresenter.selectedDate.year,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final monthlyStatistics =
                          operatorsPresenter.monthlyStatistics
                              ?.filteredSales(
                                enterprise: homePresenter.selectedEnterprise,
                                filterMonth: homePresenter.selectedDate.month,
                              )
                              .map((e) => e.toViewModel())
                              .toList();

                      final yearlyStatistics =
                          operatorsPresenter.yearlyStatistics
                              ?.filteredSales(
                                enterprise: homePresenter.selectedEnterprise,
                                filterYear: homePresenter.selectedDate.year,
                              )
                              .map((e) => e.toViewModel())
                              .toList();

                      final sales = getSales(
                          dailyStatistics: dailyStatistics,
                          monthlyStatistics: monthlyStatistics,
                          yearlyStatistics: yearlyStatistics,
                          operatorsPresenter: operatorsPresenter);

                      if (sales == null || sales.isEmpty == true) {
                        return EmptySales(isLoading: loadingSnap.data == true);
                      }

                      GetSaleStatisticsParams? lastGetParams() {
                        if (operatorsPresenter.selectedPeriod ==
                            PeriodType.daily) {
                          return operatorsPresenter.lastGetDailyParams;
                        } else if (operatorsPresenter.selectedPeriod ==
                            PeriodType.monthly) {
                          return operatorsPresenter.lastGetMonthlyParams;
                        } else if (operatorsPresenter.selectedPeriod ==
                            PeriodType.yearly) {
                          return operatorsPresenter.lastGetYearlyParams;
                        }
                        return null;
                      }

                      return Column(
                        children: [
                          ScrollableTableItem(
                            getSalesStatisticsParams: lastGetParams(),
                            selectedPeriodType:
                                operatorsPresenter.selectedPeriod,
                            titleMinHeight: isPortrait ? 43 : 25,
                            indexToSort: 1,
                            columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                            columnsIndexToSum: const [1, 2],
                            columnsWidths: const [180, 90, 80],
                            pdfFileName: R.string.operators,
                            titles: [
                              PersonalizedTableCell(
                                isTitle: true,
                                value: R.string.operator,
                              ),
                              PersonalizedTableCell(
                                isTitle: true,
                                value: R.string.total,
                              ),
                              PersonalizedTableCell(
                                isTitle: true,
                                value: R.string.salesQuantityAbbreviated,
                              ),
                            ],
                            rowValues: sales
                                .fold<
                                        Map<String,
                                            List<SaleStatisticViewModel>>>({},
                                    (map, e) {
                                  final operator =
                                      e.CashierOperator ?? "Unknown";
                                  map.putIfAbsent(operator, () => []).add(e);
                                  return map;
                                })
                                .entries
                                .map((e) {
                                  final operator = e.key;

                                  return [
                                    PersonalizedTableCell(value: operator),
                                    PersonalizedTableCell(
                                      value: e.value.sumLiquidValue(),
                                      isMoney: true,
                                    ),
                                    PersonalizedTableCell(
                                      value: e.value.quantitySales(),
                                    ),
                                  ];
                                })
                                .toList(),
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
