import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  State<SellersPage> createState() => SellersPageState();
}

class SellersPageState extends State<SellersPage> {
  bool selectedDay = true;
  bool selectedMonth = false;
  bool selectedYear = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SellersPresenter sellersPresenter = Get.find();
      sellersPresenter.emitLoadingAgain();
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
    SellersPresenter sellersPresenter = Get.find();

    return StreamBuilder(
        stream: sellersPresenter.isLoadingStream,
        builder: (context, loadinSnapshot) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadinSnapshot.data == true,
              onChangeEnterprise: (_) {},
              onTapRefresh: () {
                sellersPresenter.getSales(
                  homePresenter,
                  forceRefresh: true,
                );
              },
              onChangeDate: (newDate) {
                sellersPresenter.getSales(homePresenter);
              },
            ),
            body: SafeArea(
              child: Obx(() {
                final sales = sellersPresenter.saleMovements
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
                                PersonalizedTableCell(value: R.string.seller),
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
                                    final operator = e.Seller ?? "Unknown";
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
            ),
          );
        });
  }
}
