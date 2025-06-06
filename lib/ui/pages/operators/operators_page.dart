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

  List<SaleMovementViewModel>? getSales({
    required List<SaleMovementViewModel>? dailySales,
    required List<SaleMovementViewModel>? monthlySales,
    required List<SaleMovementViewModel>? yearlySales,
    required OperatorsPresenter operatorsPresenter,
  }) {
    if (operatorsPresenter.selectedPeriodValue == PeriodType.daily) {
      return dailySales;
    } else if (operatorsPresenter.selectedPeriodValue == PeriodType.monthly) {
      return monthlySales;
    } else if (operatorsPresenter.selectedPeriodValue == PeriodType.yearly) {
      return yearlySales;
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
                          operatorsPresenter.selectedPeriodValue,
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
                      final dailySales = operatorsPresenter.dailySales
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                            filterYear: homePresenter.selectedDate.year,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final monthlySales = operatorsPresenter.monthlySales
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final yearlySales = operatorsPresenter.yearlySales
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterYear: homePresenter.selectedDate.year,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final sales = getSales(
                          dailySales: dailySales,
                          monthlySales: monthlySales,
                          yearlySales: yearlySales,
                          operatorsPresenter: operatorsPresenter);

                      if (sales == null || sales.isEmpty == true) {
                        return EmptySales(isLoading: loadingSnap.data == true);
                      }

                      return StreamBuilder(
                          stream: homePresenter.updateScreenStream,
                          builder: (context, updateSnapshot) {
                            return Opacity(
                              opacity: updateSnapshot.data == true ? 0 : 1,
                              child: Column(
                                children: [
                                  TableItem(
                                    titleMinHeight: 43,
                                    indexToSort: 1,
                                    columnIndexToCompareAndDetachBetterAndWorstValue:
                                        1,
                                    columnsIndexToSum: [1, 2],
                                    tableColumnWidth: {
                                      0: FixedColumnWidth(
                                          MediaQuery.of(context).size.width *
                                              0.5),
                                      2: FixedColumnWidth(
                                          MediaQuery.of(context).size.width *
                                              0.18),
                                    },
                                    titles: [
                                      PersonalizedTableCell(
                                          value: R.string.operator),
                                      PersonalizedTableCell(
                                          value: R.string.total),
                                      PersonalizedTableCell(
                                        value:
                                            R.string.salesQuantityAbbreviated,
                                      ),
                                    ],
                                    rowValues: sales
                                        .fold<
                                                Map<
                                                    String,
                                                    List<
                                                        SaleMovementViewModel>>>(
                                            {}, (map, e) {
                                          final operator =
                                              e.CashierOperator ?? "Unknown";
                                          map
                                              .putIfAbsent(operator, () => [])
                                              .add(e);
                                          return map;
                                        })
                                        .entries
                                        .map((e) {
                                          final operator = e.key;

                                          return [
                                            PersonalizedTableCell(
                                                value: operator),
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
                              ),
                            );
                          });
                    }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
