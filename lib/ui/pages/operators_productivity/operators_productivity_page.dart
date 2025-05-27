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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OperatorsProductivityPresenter operatorsProductivityPresenter =
          Get.find();
      operatorsProductivityPresenter.getSales(Get.find<HomePresenter>());
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
            ),
            body: Obx(() {
              final sales = operatorsProductivityPresenter.saleMovements
                  ?.filteredSales(
                    enterprise: homePresenter.selectedEnterprise,
                    filterMonth:
                        operatorsProductivityPresenter.selectedMonth == true
                            ? homePresenter.selectedDate.month
                            : null,
                    filterDay:
                        operatorsProductivityPresenter.selectedMonth == false
                            ? homePresenter.selectedDate.day
                            : null,
                  )
                  .map((e) => e.toViewModel())
                  .toList();

              if (sales == null || sales.isEmpty) {
                return EmptySales(isLoading: loadinSnapshot.data == true);
              }

              return Column(
                children: [
                  SelectPeriodItems(items: [
                    SelectPeriodItems.createItem(
                      title: R.string.day,
                      onTap: () {
                        operatorsProductivityPresenter
                            .updateSelectedMonth(false);
                      },
                    ),
                    SelectPeriodItems.createItem(
                      title: R.string.month,
                      onTap: () {
                        operatorsProductivityPresenter
                            .updateSelectedMonth(true);
                      },
                    ),
                  ]),
                  TableItem(
                    titleMinHeight: 43,
                    indexToSort: 0,
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
                        .fold<Map<String, List<SaleMovementViewModel>>>({},
                            (map, e) {
                          final operator = e.CashierOperator ?? "Unknown";
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
          );
        });
  }
}
