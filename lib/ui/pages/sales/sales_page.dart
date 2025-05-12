import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  bool filterByHour = true;
  bool filterByDay = false;
  bool filterByMonth = false;
  bool filterByYear = false;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  void updateSelectedItem({
    bool? filterByHour,
    bool? filterByDay,
    bool? filterByMonth,
    bool? filterByYear,
  }) {
    setState(() {
      this.filterByHour = filterByHour ?? false;
      this.filterByDay = filterByDay ?? false;
      this.filterByMonth = filterByMonth ?? false;
      this.filterByYear = filterByYear ?? false;
    });
  } //TODO move this to presenter

  Future<void> reloadSales({
    required HomePresenter homePresenter,
    required ResumePresenter resumePresenter,
    required SalesPresenter salesPresenter,
    bool? forceRefresh,
  }) async {
    await salesPresenter.getSales(
      homePresenter: homePresenter,
      resumePresenter: resumePresenter,
      searchByHour: filterByHour,
      searchByDay: filterByDay,
      searchByMonth: filterByMonth,
      searchByYear: filterByYear,
      forceRefresh: forceRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, salesPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, salesPresenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeEnterprise: (_) async {
          await reloadSales(
            homePresenter: homePresenter,
            resumePresenter: resumePresenter,
            salesPresenter: salesPresenter,
          );
        },
        onTapRefresh: () async {
          await reloadSales(
            homePresenter: homePresenter,
            resumePresenter: resumePresenter,
            salesPresenter: salesPresenter,
            forceRefresh: true,
          );
        },
        onChangeDate: (_) async {
          await reloadSales(
            homePresenter: homePresenter,
            resumePresenter: resumePresenter,
            salesPresenter: salesPresenter,
          );
        },
      ),
      body: StreamBuilder<bool>(
          stream: homePresenter.updateScreenStream,
          builder: (context, snapshot) {
            return Obx(() {
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

              final saleMovementsByMonth = salesPresenter.saleMovementsByMonth;
              final saleMovementsByYear = salesPresenter.saleMovementsByYear;

              return Opacity(
                opacity: snapshot.data == true ? 0 : 1,
                child: Column(
                  children: [
                    PeriodItems(updateSelectedItem: updateSelectedItem),
                    if (filterByHour &&
                        resumeSaleMovements != null &&
                        uniqueHours.isNotEmpty)
                      HourTable(
                        resumeSaleMovements: resumeSaleMovements,
                        uniqueHours: uniqueHours,
                      ),
                    if (filterByDay && resumeSaleMovements != null)
                      DayTable(resumeSaleMovements: resumeSaleMovements),
                    if (filterByMonth &&
                        saleMovementsByMonth != null &&
                        saleMovementsByMonth.isNotEmpty)
                      MonthSales(saleMovementsByMonth: saleMovementsByMonth),
                    if (filterByYear &&
                        saleMovementsByYear != null &&
                        saleMovementsByYear.isNotEmpty)
                      YearSales(saleMovementsByYear: saleMovementsByYear),
                  ],
                ),
              );
            });
          }),
    );
  }
}
