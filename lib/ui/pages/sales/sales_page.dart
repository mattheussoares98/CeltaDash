import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../ui/mixins/mixins.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>
    with LoadingManager, UIErrorManager {
  // StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  bool salesAreEmpty({
    required List<SaleStatisticViewModel>? dailyStatistics,
    required List<SaleStatisticViewModel>? monthlyStatistics,
    required List<SaleStatisticViewModel>? yearlyStatistics,
    required SalesPresenter salesPresenter,
  }) {
    if (salesPresenter.selectedPeriodValue == PeriodType.daily) {
      return dailyStatistics?.isEmpty == true;
    } else if (salesPresenter.selectedPeriodValue == PeriodType.monthly) {
      return monthlyStatistics?.isEmpty == true;
    } else if (salesPresenter.selectedPeriodValue == PeriodType.yearly) {
      return yearlyStatistics?.isEmpty == true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();

    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    // loadingSubscription =
    //     handleLoading(context, salesPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, salesPresenter.mainErrorStream);

    return StreamBuilder(
        stream: salesPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                );
              },
              onChangeDate: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                );
              },
              onTapRefresh: () {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  forceRefresh: true,
                );
              },
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectPeriodItems(
                        isLoading: loadingSnap.data,
                        selectedPeriodType: salesPresenter.selectedPeriodValue,
                        onTapDaily: () {
                          salesPresenter.getSales(
                            homePresenter,
                            periodType: PeriodType.daily,
                          );
                        },
                        onTapMonthly: () {
                          salesPresenter.getSales(
                            homePresenter,
                            periodType: PeriodType.monthly,
                          );
                        },
                        onTapYearly: () {
                          salesPresenter.getSales(
                            homePresenter,
                            periodType: PeriodType.yearly,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  // final uniqueHours = resumeSaleMovements
                  //     .uniqueHours(
                  //       enterprise: homePresenter.selectedEnterprise,
                  //       filterDay: homePresenter.selectedDate.day,
                  //       filterMonth: homePresenter.selectedDate.month,
                  //       filterYear: homePresenter.selectedDate.year,
                  //     )
                  //     .toList();

                  final dailyStatistics = salesPresenter.dailyStatistics
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel())
                      .toList();

                  final monthlyStatistics = salesPresenter.monthlyStatistics
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel())
                      .toList();

                  final yearlyStatistics = salesPresenter.yearlyStatistics
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel())
                      .toList();

                  if (salesAreEmpty(
                      dailyStatistics: dailyStatistics,
                      monthlyStatistics: monthlyStatistics,
                      yearlyStatistics: yearlyStatistics,
                      salesPresenter: salesPresenter)) {
                    return EmptySales(isLoading: loadingSnap.data == true);
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // if (uniqueHours.isNotEmpty)
                              //   HourTable(
                              //     resumeSaleMovements: resumeSaleMovements,
                              //     uniqueHours: uniqueHours,
                              //   ),
                              //TODO implement in presenter
                              if (salesPresenter.selectedPeriodValue ==
                                      PeriodType.daily &&
                                  dailyStatistics?.isNotEmpty == true)
                                DayTable(dailyStatistics: dailyStatistics!),
                              if (salesPresenter.selectedPeriodValue ==
                                      PeriodType.monthly &&
                                  monthlyStatistics != null &&
                                  monthlyStatistics.isNotEmpty)
                                MonthSales(
                                    saleStatisticsByMonth: monthlyStatistics),
                              if (salesPresenter.selectedPeriodValue ==
                                      PeriodType.yearly &&
                                  yearlyStatistics != null &&
                                  yearlyStatistics.isNotEmpty)
                                YearSales(
                                    saleStatisticsByYear: yearlyStatistics),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        });
  }
}
