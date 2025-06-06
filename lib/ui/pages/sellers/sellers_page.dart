import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SellersPresenter sellersPresenter = Get.find();
      HomePresenter homePresenter = Get.find();
      sellersPresenter.getSales(homePresenter);
    });
  }

  List<SaleMovementViewModel>? getSales({
    required List<SaleMovementViewModel>? dailySales,
    required List<SaleMovementViewModel>? monthlySales,
    required List<SaleMovementViewModel>? yearlySales,
    required SellersPresenter sellersPresenter,
  }) {
    if (sellersPresenter.selectedPeriodValue == PeriodType.daily) {
      return dailySales;
    } else if (sellersPresenter.selectedPeriodValue == PeriodType.monthly) {
      return monthlySales;
    } else if (sellersPresenter.selectedPeriodValue == PeriodType.yearly) {
      return yearlySales;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    SellersPresenter sellersPresenter = Get.find();

    return StreamBuilder(
        stream: sellersPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                sellersPresenter.getSales(homePresenter);
              },
              onChangeDate: (_) {
                sellersPresenter.getSales(homePresenter);
              },
              onTapRefresh: () {
                sellersPresenter.getSales(
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
                      selectedPeriodType: sellersPresenter.selectedPeriodValue,
                      onTapDaily: () {
                        sellersPresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.daily,
                        );
                      },
                      onTapMonthly: () {
                        sellersPresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.monthly,
                        );
                      },
                      onTapYearly: () {
                        sellersPresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.yearly,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final dailySales = sellersPresenter.dailySales
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                            filterYear: homePresenter.selectedDate.year,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final monthlySales = sellersPresenter.monthlySales
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final yearlySales = sellersPresenter.yearlySales
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
                          sellersPresenter: sellersPresenter);

                      if (sales == null || sales.isEmpty == true) {
                        return EmptySales(isLoading: loadingSnap.data == true);
                      }

                      return Column(
                        children: [
                          TableItem(
                            titleMinHeight: 43,
                            indexToSort: 1,
                            columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                            columnsIndexToSum: [1, 2],
                            tableColumnWidth: {
                              0: FixedColumnWidth(
                                  MediaQuery.of(context).size.width * 0.5),
                              2: FixedColumnWidth(
                                  MediaQuery.of(context).size.width * 0.18),
                            },
                            titles: [
                              PersonalizedTableCell(value: R.string.seller),
                              PersonalizedTableCell(value: R.string.total),
                              PersonalizedTableCell(
                                value: R.string.salesQuantityAbbreviated,
                              ),
                            ],
                            rowValues: sales
                                .fold<Map<String, List<SaleMovementViewModel>>>(
                                    {}, (map, e) {
                                  final seller = e.Seller ?? "Unknown";
                                  map.putIfAbsent(seller, () => []).add(e);
                                  return map;
                                })
                                .entries
                                .map((e) {
                                  final seller = e.key;

                                  return [
                                    PersonalizedTableCell(value: seller),
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
