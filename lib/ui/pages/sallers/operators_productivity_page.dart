import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class OperatorsProductivityPage extends StatefulWidget {
  const OperatorsProductivityPage({super.key});

  @override
  State<OperatorsProductivityPage> createState() =>
      _OperatorsProductivityPageState();
}

class _OperatorsProductivityPageState extends State<OperatorsProductivityPage> {
  bool selectedDay = true;
  bool selectedMonth = false;
  bool selectedYear = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OperatorsPresenter operatorsPresenter = Get.find();
      operatorsPresenter.emitLoadingAgain();
    });
  }

  void updateSelectedPeriod({
    bool? day,
    bool? month,
    bool? year,
  }) {
    setState(() {
      selectedDay = day ?? false;
      selectedMonth = month ?? false;
      selectedYear = year ?? false;
    });
  }

  int get indexToSelectWhenRebuild {
    if (selectedDay) {
      return 0;
    } else if (selectedMonth) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    OperatorsPresenter operatorsPresenter = Get.find();

    return StreamBuilder(
        stream: operatorsPresenter.isLoadingStream,
        builder: (context, loadinSnapshot) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadinSnapshot.data == true,
              onChangeEnterprise: (_) {},
              onTapRefresh: () {
                operatorsPresenter.getSales(
                  homePresenter,
                  forceRefresh: true,
                );
              },
              onChangeDate: (newDate) {
                operatorsPresenter.getSales(homePresenter);
              },
            ),
            body: SafeArea(
              child: Obx(() {
                //TODO fix
                final sales = operatorsPresenter.dailySales
                    ?.filteredSales(
                      enterprise: homePresenter.selectedEnterprise,
                      filterDay: selectedDay == true
                          ? homePresenter.selectedDate.day
                          : null,
                      filterMonth: selectedMonth == true
                          ? homePresenter.selectedDate.month
                          : null,
                      filterYear: selectedYear == true
                          ? homePresenter.selectedDate.year
                          : null,
                    )
                    .map((e) => e.toViewModel())
                    .toList();

                if (sales == null || sales.isEmpty) {
                  return EmptySales(isLoading: loadinSnapshot.data == true);
                }

                //TODO remove this page

                return Column(
                  children: [
                    SelectPeriodItems(
                      isLoading: loadinSnapshot.data,
                      selectedPeriodType: PeriodType.daily,
                    ),
                    TableItem(
                      titleMinHeight: 43,
                      indexToSort: 1,
                      columnIndexToCompareAndDetachBetterAndWorstValue:
                          1,
                      columnsIndexToSum: [1, 2],
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
                                      List<SaleMovementViewModel>>>({},
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
          );
        });
  }
}
