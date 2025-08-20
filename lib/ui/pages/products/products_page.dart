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
  bool _initialLoadFinished = false;

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
      if (mounted) {
        final productsPresenter = Get.find<ProductsPresenter>();

        productsPresenter.getSales();
        setState(() {
          _initialLoadFinished = true;
        });

        mainErrorSubscription =
            handleMainError(context, productsPresenter.mainErrorStream);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultSafeArea(
      child: StreamBuilder(
          stream: productsPresenter.isLoadingStream,
          builder: (context, loadingSnap) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: DefaultAppBar(
                showEnterpriseManagerButton: true,
                isLoading: loadingSnap.data == true,
                onChangeEnterprise: (_) {
                  productsPresenter.getSales();
                },
                onChangeDate: (_) {
                  productsPresenter.getSales();
                },
                onTapRefresh: () {
                  productsPresenter.getSales(forceRefresh: true);
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
                  return e.Product?.toLowerCase().contains(
                          filterProductController.text.toLowerCase()) ??
                      false;
                }).toList();

                if (!_initialLoadFinished) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(isPortrait ? 8.0 : 4),
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
                                  periodType: PeriodType.daily,
                                );
                              },
                              onTapMonthly: () {
                                productsPresenter.getSales(
                                  periodType: PeriodType.monthly,
                                );
                              },
                            ),
                          Expanded(
                            child: FilterProductField(
                              filterProductController: filterProductController,
                              setState: setState,
                              isLoading: loadingSnap.data == true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (sales == null || sales.isEmpty)
                      Expanded(
                          child:
                              EmptySales(isLoading: loadingSnap.data == true)),
                    if (sales != null && sales.isNotEmpty)
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
          }),
    );
  }
}
