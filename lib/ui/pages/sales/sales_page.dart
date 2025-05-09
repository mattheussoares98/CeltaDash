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

  Future<void> reloadSales(HomePresenter homePresenter) async {
    await widget.presenter.getSales(
      homePresenter: homePresenter,
      searchByHour: filterByHour,
      searchByDay: filterByDay,
      searchByMonth: filterByMonth,
      searchByYear: filterByYear,
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
          await reloadSales(homePresenter);
        },
        onTapRefresh: () async {
          await reloadSales(homePresenter);
        },
        onChangeDate: (_) async {
          await reloadSales(homePresenter);
        },
      ),
      body: Obx(() {
        Get.put<SalesPresenter>(widget.presenter);
        final saleMovements = widget.presenter.saleMovements;

        return StreamBuilder<bool>(
            stream: homePresenter.updateScreenStream,
            builder: (context, snapshot) {
              return Opacity(
                opacity: snapshot.data == true ? 0 : 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectPeriodItems(
                            items: [
                              SelectPeriodItems.createItem(
                                title: R.string.hour,
                                onTap: () {
                                  updateSelectedItem(filterByHour: true);
                                },
                              ),
                              SelectPeriodItems.createItem(
                                title: R.string.day,
                                onTap: () {
                                  updateSelectedItem(filterByDay: true);
                                },
                              ),
                              SelectPeriodItems.createItem(
                                title: R.string.month,
                                onTap: () {
                                  updateSelectedItem(filterByMonth: true);
                                },
                              ),
                              SelectPeriodItems.createItem(
                                title: R.string.year,
                                onTap: () {
                                  updateSelectedItem(filterByYear: true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (filterByHour && saleMovements != null)
                      HourTable(saleMovements: saleMovements),
                  ],
                ),
              );
            });
      }),
    );
  }
}
