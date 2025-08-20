import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

bool _showAnimation = true;

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

      sellersPresenter.getSales();
    });
  }

  List<SaleStatisticViewModel>? getSales({
    required List<SaleStatisticViewModel>? dailyStatistics,
    required List<SaleStatisticViewModel>? monthlyStatistics,
    required List<SaleStatisticViewModel>? yearlyStatistics,
    required SellersPresenter sellersPresenter,
  }) {
    if (sellersPresenter.selectedPeriod == PeriodType.daily) {
      return dailyStatistics;
    } else if (sellersPresenter.selectedPeriod == PeriodType.monthly) {
      return monthlyStatistics;
    } else if (sellersPresenter.selectedPeriod == PeriodType.yearly) {
      return yearlyStatistics;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    SellersPresenter sellersPresenter = Get.find();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return StreamBuilder(
        stream: sellersPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            body: DefaultSafeArea(
              child: Column(
                children: [
                  DefaultAppBar(
                    isLoading: loadingSnap.data == true,
                    onChangeEnterprise: (_) {
                      sellersPresenter.getSales();
                    },
                    onChangeDate: (_) {
                      sellersPresenter.getSales();
                    },
                    onTapRefresh: () {
                      sellersPresenter.getSales(forceRefresh: true);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(isPortrait ? 8 : 0),
                    child: SelectPeriodItems(
                      isLoading: loadingSnap.data,
                      selectedPeriodType: sellersPresenter.selectedPeriod,
                      onTapDaily: () {
                        sellersPresenter.getSales(
                          periodType: PeriodType.daily,
                        );
                      },
                      onTapMonthly: () {
                        sellersPresenter.getSales(
                          periodType: PeriodType.monthly,
                        );
                      },
                      onTapYearly: () {
                        sellersPresenter.getSales(
                          periodType: PeriodType.yearly,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final dailyStatistics = sellersPresenter.dailyStatistics
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                            filterYear: homePresenter.selectedDate.year,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final monthlyStatistics =
                          sellersPresenter.monthlyStatistics
                              ?.filteredSales(
                                enterprise: homePresenter.selectedEnterprise,
                                filterMonth: homePresenter.selectedDate.month,
                              )
                              .map((e) => e.toViewModel())
                              .toList();

                      final yearlyStatistics = sellersPresenter.yearlyStatistics
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
                          sellersPresenter: sellersPresenter);

                      if (sales == null || sales.isEmpty == true) {
                        return EmptySales(isLoading: loadingSnap.data == true);
                      }

                      GetSaleStatisticsParams? lastGetParams() {
                        if (sellersPresenter.selectedPeriod ==
                            PeriodType.daily) {
                          return sellersPresenter.lastGetDailyParams;
                        } else if (sellersPresenter.selectedPeriod ==
                            PeriodType.monthly) {
                          return sellersPresenter.lastGetMonthlyParams;
                        } else if (sellersPresenter.selectedPeriod ==
                            PeriodType.yearly) {
                          return sellersPresenter.lastGetYearlyParams;
                        }
                        return null;
                      }

                      return Column(
                        children: [
                          ScrollableTableItem(
                            getSalesStatisticsParams: lastGetParams(),
                            titleMinHeight: isPortrait ? 43 : 30,
                            indexToSort: 1,
                            columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                            columnsIndexToSum: [1, 2],
                            pdfFileName: R.string.sellers,
                            showAnimation: _showAnimation,
                            selectedPeriodType: sellersPresenter.selectedPeriod,
                            fixFirstColumn: true,
                            hideShowAnimation: () {
                              _showAnimation = false;
                            },
                            columnsWidths: [150, 120, 70],
                            titles: [
                              PersonalizedTableCell(
                                  value: R.string.seller, isTitle: true),
                              PersonalizedTableCell(
                                  value: R.string.total, isTitle: true),
                              PersonalizedTableCell(
                                  value: R.string.salesQuantityAbbreviated,
                                  isTitle: true),
                            ],
                            rowValues: sales
                                .fold<
                                        Map<String,
                                            List<SaleStatisticViewModel>>>({},
                                    (map, e) {
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
