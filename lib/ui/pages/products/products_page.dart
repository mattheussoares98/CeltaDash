import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

bool _showAnimation = true;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final products = Get.find<ProductsPresenter>();
      final homePresenter = Get.find<HomePresenter>();
      await products.getSales(homePresenter);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    mainErrorSubscription =
        handleMainError(context, productsPresenter.mainErrorStream);

    return StreamBuilder(
        stream: productsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              showEnterpriseManagerButton: true,
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                productsPresenter.getSales(homePresenter);
              },
              onChangeDate: (_) {
                productsPresenter.getSales(homePresenter);
              },
              onTapRefresh: () {
                productsPresenter.getSales(homePresenter, forceRefresh: true);
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
                        if (homePresenter.enterprises != null &&
                            homePresenter.enterprises!.isNotEmpty)
                          SelectPeriodItems(
                            isLoading: loadingSnap.data,
                            selectedPeriodType:
                                productsPresenter.selectedPeriod,
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
                    showAnimation: _showAnimation,
                    isLoading: loadingSnap.data == true,
                    hideShowAnimation: () {
                      _showAnimation = false;
                    },
                  ),
                ],
              );
            }),
          );
        });
  }
}
