import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

bool showAnimation = true;

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with UIErrorManager {
  StreamSubscription? mainErrorSubscription;
  final filterProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    filterProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();

    mainErrorSubscription =
        handleMainError(context, productsPresenter.mainErrorStream);

    return StreamBuilder(
        stream: productsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  now: DateTime.now(),
                );
              },
              onChangeDate: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  now: DateTime.now(),
                );
              },
              onTapRefresh: () {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  forceRefresh: true,
                  now: DateTime.now(),
                );
              },
            ),
            body: Obx(() {
              final dailyStatistics = productsPresenter.dailyStatistics
                  ?.filteredSales(
                    enterprise: homePresenter.selectedEnterprise,
                    filterMonth: homePresenter.selectedDate.month,
                    filterDay:
                        productsPresenter.selectedPeriod == PeriodType.daily
                            ? homePresenter.selectedDate.day
                            : null,
                    filterYear: homePresenter.selectedDate.year,
                  )
                  .map((e) => e.toViewModel())
                  .toList();

              final monthlyStatistics = productsPresenter.monthlyStatistics
                  ?.filteredSales(
                    enterprise: homePresenter.selectedEnterprise,
                    filterMonth: homePresenter.selectedDate.month,
                    filterYear: homePresenter.selectedDate.year,
                  )
                  .map((e) => e.toViewModel())
                  .toList();

              final sales =
                  (productsPresenter.selectedPeriod == PeriodType.daily
                          ? dailyStatistics
                          : monthlyStatistics)
                      ?.where((e) {
                return e.Product?.toLowerCase()
                        .contains(filterProductController.text.toLowerCase()) ??
                    false;
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectPeriodItems(
                          isLoading: loadingSnap.data,
                          selectedPeriodType: productsPresenter.selectedPeriod,
                          onTapDaily: () {
                            productsPresenter.getSales(
                              homePresenter,
                              periodType: PeriodType.daily,
                            );
                          },
                          onTapMonthly: () {
                            productsPresenter.getSales(
                              homePresenter,
                              periodType: PeriodType.monthly,
                            );
                          },
                        ),
                        if (sales != null)
                          Expanded(
                            child: FilterProductField(
                              filterProductController: filterProductController,
                              setState: setState,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ProductsTable(
                    sales: sales,
                    showAnimation: showAnimation,
                    isLoading: loadingSnap.data == true,
                    hideShowAnimation: () {
                      showAnimation = false;
                    },
                  ),
                ],
              );
            }),
          );
        });
  }
}
