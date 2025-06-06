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
    required List<SaleMovementViewModel>? dailySales,
    required List<SaleMovementViewModel>? monthlySales,
    required List<SaleMovementViewModel>? yearlySales,
    required SalesPresenter salesPresenter,
  }) {
    if (salesPresenter.selectedPeriodValue == PeriodType.daily) {
      return dailySales?.isEmpty == true;
    } else if (salesPresenter.selectedPeriodValue == PeriodType.monthly) {
      return monthlySales?.isEmpty == true;
    } else if (salesPresenter.selectedPeriodValue == PeriodType.yearly) {
      return yearlySales?.isEmpty == true;
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
            body: StreamBuilder<bool>(
                stream: homePresenter.updateScreenStream,
                builder: (context, snapshot) {
                  return Obx(() {
                    // final uniqueHours = resumeSaleMovements
                    //     .uniqueHours(
                    //       enterprise: homePresenter.selectedEnterprise,
                    //       filterDay: homePresenter.selectedDate.day,
                    //       filterMonth: homePresenter.selectedDate.month,
                    //       filterYear: homePresenter.selectedDate.year,
                    //     )
                    //     .toList();

                    final dailySales = salesPresenter.saleMovementsByDay
                        ?.filteredSales(
                          enterprise: homePresenter.selectedEnterprise,
                        )
                        .map((e) => e.toViewModel())
                        .toList();

                    final monthlySales = salesPresenter.saleMovementsByMonth
                        ?.filteredSales(
                          enterprise: homePresenter.selectedEnterprise,
                        )
                        .map((e) => e.toViewModel())
                        .toList();

                    final yearlySales = salesPresenter.saleMovementsByYear
                        ?.filteredSales(
                          enterprise: homePresenter.selectedEnterprise,
                        )
                        .map((e) => e.toViewModel())
                        .toList();

                    if (salesAreEmpty(
                        dailySales: dailySales,
                        monthlySales: monthlySales,
                        yearlySales: yearlySales,
                        salesPresenter: salesPresenter)) {
                      return EmptySales(isLoading: loadingSnap.data == true);
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectPeriodItems(
                                selectedPeriodType:
                                    salesPresenter.selectedPeriodValue,
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
                        Expanded(
                          child: Opacity(
                            opacity: snapshot.data == true ? 0 : 1,
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
                                    dailySales?.isNotEmpty == true)
                                  DayTable(resumeSaleMovements: dailySales!),
                                if (salesPresenter.selectedPeriodValue ==
                                        PeriodType.monthly &&
                                    monthlySales != null &&
                                    monthlySales.isNotEmpty)
                                  MonthSales(
                                      saleMovementsByMonth: monthlySales),
                                if (salesPresenter.selectedPeriodValue ==
                                        PeriodType.yearly &&
                                    yearlySales != null &&
                                    yearlySales.isNotEmpty)
                                  YearSales(saleMovementsByYear: yearlySales),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                }),
          );
        });
  }
}
