import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
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
      HomePresenter homePresenter = Get.find();
      operatorsPresenter.getSales(homePresenter);
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

    return StreamBuilder(
        stream: operatorsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                operatorsPresenter.getSales(homePresenter);
              },
              onChangeDate: (_) {
                operatorsPresenter.getSales(homePresenter);
              },
              onTapRefresh: () {
                operatorsPresenter.getSales(
                  homePresenter,
                  forceRefresh: true,
                );
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectPeriodItems(
                      isLoading: loadingSnap.data,
                      selectedPeriodType:
                          operatorsPresenter.selectedPeriod,
                      onTapDaily: () {
                        operatorsPresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.daily,
                        );
                      },
                      onTapMonthly: () {
                        operatorsPresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.monthly,
                        );
                      },
                      onTapYearly: () {
                        operatorsPresenter.getSales(
                          homePresenter,
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

                      final monthlyStatistics = operatorsPresenter.monthlyStatistics
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final yearlyStatistics = operatorsPresenter.yearlyStatistics
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

                      return Column(
                        children: [
                          TableItem(
                            titleMinHeight: 43,
                            indexToSort: 1,
                            columnIndexToCompareAndDetachBetterAndWorstValue:
                                1,
                            columnsIndexToSum: [1, 2],
                            tableColumnWidth: {
                              0: FixedColumnWidth(
                                  MediaQuery.of(context).size.width * 0.5),
                              2: FixedColumnWidth(
                                  MediaQuery.of(context).size.width * 0.18),
                            },
                            titles: [
                              PersonalizedTableCell(value: R.string.operator),
                              PersonalizedTableCell(value: R.string.total),
                              PersonalizedTableCell(
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
