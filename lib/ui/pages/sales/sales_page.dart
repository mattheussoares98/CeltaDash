import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/mixins/mixins.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SalesPage extends StatefulWidget {
  final SalesPresenter presenter;
  const SalesPage({
    super.key,
    required this.presenter,
  });

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
  }

  Future<void> reloadSales(
    HomePresenter homePresenter, {
    bool? forceRefresh,
  }) async {
    await widget.presenter.getSales(
      homePresenter: homePresenter,
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

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeEnterprise: (_) async {
          await reloadSales(homePresenter, forceRefresh: true);
        },
        onTapRefresh: () async {
          await reloadSales(homePresenter, forceRefresh: true);
        },
        onChangeDate: (_) async {
          await reloadSales(homePresenter);
        },
      ),
      body: StreamBuilder<bool>(
          stream: homePresenter.updateScreenStream,
          builder: (context, snapshot) {
            return Obx(() {
              Get.put<SalesPresenter>(widget.presenter);
              final saleMovements = widget.presenter.saleMovements
                  ?.filteredSales(
                    enterprise: homePresenter.selectedEnterprise,
                  )
                  .map((e) => e.toViewModel())
                  .toList();

              final uniqueHours = saleMovements == null
                  ? <String>[]
                  : saleMovements
                      .uniqueHours(
                        enterprise: homePresenter.selectedEnterprise,
                        filterDay: homePresenter.selectedDate.day,
                        filterMonth: homePresenter.selectedDate.month,
                        filterYear: homePresenter.selectedDate.year,
                      )
                      .toList();

              return Opacity(
                opacity: snapshot.data == true ? 0 : 1,
                child: Column(
                  children: [
                    PeriodItems(updateSelectedItem: updateSelectedItem),
                    if (filterByHour &&
                        saleMovements != null &&
                        uniqueHours.isNotEmpty)
                      HourTable(
                        saleMovements: saleMovements,
                        uniqueHours: uniqueHours,
                      ),
                    if (filterByDay && saleMovements != null)
                      DayTable(saleMovements: saleMovements)
                  ],
                ),
              );
            });
          }),
    );
  }
}
