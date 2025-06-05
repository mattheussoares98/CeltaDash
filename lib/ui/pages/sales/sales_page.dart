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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();

    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    // loadingSubscription =
    //     handleLoading(context, salesPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, salesPresenter.mainErrorStream);

    return StreamBuilder(
        stream: salesPresenter.isLoadingStream,
        builder: (context, isLoadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: isLoadingSnap.data == true,
              onChangeEnterprise: (_) {
                salesPresenter.getSales(homePresenter);
              },
              onChangeDate: (_) {
                salesPresenter.getSales(homePresenter);
              },
              onTapRefresh: () {
                salesPresenter.getSales(homePresenter, forceRefresh: true);
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

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectPeriodItems(
                                selectedPeriodType:
                                    salesPresenter.selectedPeriodType,
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
                                if (salesPresenter.selectedPeriodType ==
                                        PeriodType.daily &&
                                    dailySales?.isNotEmpty == true)
                                  DayTable(resumeSaleMovements: dailySales!),
                                if (salesPresenter.selectedPeriodType ==
                                        PeriodType.monthly &&
                                    monthlySales != null &&
                                    monthlySales.isNotEmpty)
                                  MonthSales(
                                      saleMovementsByMonth: monthlySales),
                                if (salesPresenter.selectedPeriodType ==
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
