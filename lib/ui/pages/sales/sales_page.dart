import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/mixins/mixins.dart';
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
      if (mounted) {
        SalesPresenter salesPresenter = Get.find();
        setState(() {
          salesPresenter.updateSelectedPeriod(filterByHour: true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();

    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    // loadingSubscription =
    //     handleLoading(context, salesPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, salesPresenter.mainErrorStream);

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: homePresenter.updateScreenStream,
          builder: (context, snapshot) {
            return Column(
              children: [
                PeriodItems(
                    updateSelectedItem: salesPresenter.updateSelectedPeriod),
                Expanded(
                  child: Obx(() {
                    final resumeSaleMovements = resumePresenter.saleMovements
                        ?.filteredSales(
                          enterprise: homePresenter.selectedEnterprise,
                        )
                        .map((e) => e.toViewModel())
                        .toList();

                    final uniqueHours = resumeSaleMovements == null
                        ? <String>[]
                        : resumeSaleMovements
                            .uniqueHours(
                              enterprise: homePresenter.selectedEnterprise,
                              filterDay: homePresenter.selectedDate.day,
                              filterMonth: homePresenter.selectedDate.month,
                              filterYear: homePresenter.selectedDate.year,
                            )
                            .toList();

                    final saleMovementsByMonth =
                        salesPresenter.saleMovementsByMonth
                            ?.filteredSales(
                              enterprise: homePresenter.selectedEnterprise,
                              filterYear: homePresenter.selectedDate.year,
                            )
                            .map((e) => e.toViewModel())
                            .toList();

                    final saleMovementsByYear =
                        salesPresenter.saleMovementsByYear
                            ?.filteredSales(
                              enterprise: homePresenter.selectedEnterprise,
                            )
                            .map((e) => e.toViewModel())
                            .toList();

                    return Opacity(
                      opacity: snapshot.data == true ? 0 : 1,
                      child: Column(
                        children: [
                          if (salesPresenter.filterByHour &&
                              resumeSaleMovements != null &&
                              uniqueHours.isNotEmpty)
                            HourTable(
                              resumeSaleMovements: resumeSaleMovements,
                              uniqueHours: uniqueHours,
                            ),
                          if (salesPresenter.filterByDay &&
                              resumeSaleMovements != null)
                            DayTable(resumeSaleMovements: resumeSaleMovements),
                          if (salesPresenter.filterByMonth &&
                              saleMovementsByMonth != null &&
                              saleMovementsByMonth.isNotEmpty)
                            MonthSales(
                                saleMovementsByMonth: saleMovementsByMonth),
                          if (salesPresenter.filterByYear &&
                              saleMovementsByYear != null &&
                              saleMovementsByYear.isNotEmpty)
                            YearSales(saleMovementsByYear: saleMovementsByYear),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            );
          }),
    );
  }
}
