import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/helpers/helpers.dart';
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
      OperatorsProductivityPresenter operatorsProductivityPresenter =
          Get.find();
      operatorsProductivityPresenter.getSales(Get.find<HomePresenter>());
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

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    OperatorsProductivityPresenter operatorsProductivityPresenter = Get.find();

    return StreamBuilder(
        stream: operatorsProductivityPresenter.isLoadingStream,
        builder: (context, loadinSnapshot) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadinSnapshot.data == true,
              onChangeEnterprise: (_) {},
              onChangeDate: (newDate) {
                operatorsProductivityPresenter.getSales(homePresenter);
              },
            ),
            body: Obx(() {
              final sales = operatorsProductivityPresenter.saleMovements
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

              return StreamBuilder(
                  stream: homePresenter.updateScreenStream,
                  builder: (context, updateSnapshot) {
                    return Opacity(
                      opacity: updateSnapshot.data == true ? 0 : 1,
                      child: Column(
                        children: [
                          SelectPeriodItems(items: [
                            SelectPeriodItems.createItem(
                              title: R.string.day,
                              onTap: () {
                                updateSelectedPeriod(day: true);
                              },
                            ),
                            SelectPeriodItems.createItem(
                              title: R.string.month,
                              onTap: () {
                                updateSelectedPeriod(month: true);
                              },
                            ),
                            SelectPeriodItems.createItem(
                              title: R.string.year,
                              onTap: () {
                                updateSelectedPeriod(year: true);
                              },
                            ),
                          ]),
                          TableItem(
                            titleMinHeight: 43,
                            indexToSort: 1,
                            columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                            columnsIndexToSum: [1, 2],
                            titles: [
                              PersonalizedTableCell(value: R.string.operator),
                              PersonalizedTableCell(value: R.string.total),
                              PersonalizedTableCell(
                                value: R.string.salesQuantityAbbreviated,
                              ),
                            ],
                            rowValues: sales
                                .fold<Map<String, List<SaleMovementViewModel>>>(
                                    {}, (map, e) {
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
                      ),
                    );
                  });
            }),
          );
        });
  }
}
