import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class ProfitabilityPage extends StatefulWidget {
  const ProfitabilityPage({super.key});

  @override
  State<ProfitabilityPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<ProfitabilityPage>
    with UIErrorManager {
  int selectedPageIndex = 0;
  final pageController = PageController();
  StreamSubscription? departmentsErrorSubscription;

  Future<void> reloadData({
    bool? forceRefresh,
  }) async {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    DepartmentsPresenter departmentsPresenter = Get.find();

    departmentsPresenter.getSales(homePresenter, forceRefresh: forceRefresh);
    productsPresenter.getSales(homePresenter, forceRefresh: forceRefresh);
  }

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        reloadData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    departmentsErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    DepartmentsPresenter departmentsPresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    departmentsErrorSubscription?.cancel();
    departmentsErrorSubscription =
        handleMainError(context, departmentsPresenter.mainErrorStream);

    return StreamBuilder(
        stream: productsPresenter.isLoadingStream,
        builder: (context, loadingProductsSnap) {
          return StreamBuilder(
              stream: departmentsPresenter.isLoadingStream,
              builder: (context, loadingDepartmentsSnap) {
                return Scaffold(
                  appBar: DefaultAppBar(
                    isLoading: loadingProductsSnap.data == true ||
                        loadingDepartmentsSnap.data == true,
                    onChangeEnterprise: (_) {
                      reloadData();
                    },
                    onChangeDate: (_) {
                      reloadData();
                    },
                    onTapRefresh: () {
                      reloadData(forceRefresh: true);
                    },
                  ),
                  body: SafeArea(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectPeriodItems(
                              isLoading: loadingProductsSnap.data == true ||
                                  loadingDepartmentsSnap.data == true,
                              selectedPeriodType:
                                  departmentsPresenter.selectedPeriod,
                              onTapDaily: () {
                                departmentsPresenter.getSales(
                                  homePresenter,
                                  periodType: PeriodType.daily,
                                );
                              },
                              onTapMonthly: () {
                                departmentsPresenter.getSales(
                                  homePresenter,
                                  periodType: PeriodType.monthly,
                                );
                              },
                            ),
                          ),
                          DefaultTabBar(
                            tabs: [
                              DefaultTab(
                                title: R.string.departments,
                                materialIcon: Icons.apartment,
                                cupertinoIcon: CupertinoIcons.building_2_fill,
                              ),
                              DefaultTab(
                                title: R.string.sections,
                                materialIcon: Icons.view_module,
                                cupertinoIcon: CupertinoIcons.square_grid_2x2,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Obx(() {
                              final dailyStatistics = departmentsPresenter
                                  .dailyStatistics
                                  ?.filteredSales(
                                    enterprise:
                                        homePresenter.selectedEnterprise,
                                    filterDay: homePresenter.selectedDate.day,
                                    filterMonth:
                                        homePresenter.selectedDate.month,
                                    filterYear: homePresenter.selectedDate.year,
                                  )
                                  .map((e) => e.toViewModel())
                                  .toList();
                              final monthlyStatistics =
                                  departmentsPresenter.monthlyStatistics
                                      ?.filteredSales(
                                        enterprise:
                                            homePresenter.selectedEnterprise,
                                        filterMonth:
                                            homePresenter.selectedDate.month,
                                      )
                                      .map((e) => e.toViewModel())
                                      .toList();

                              final salesDepartments =
                                  departmentsPresenter.selectedPeriod ==
                                          PeriodType.daily
                                      ? dailyStatistics
                                      : monthlyStatistics;

                              if (salesDepartments == null ||
                                  salesDepartments.isEmpty) {
                                return EmptySales(
                                    isLoading: loadingDepartmentsSnap.data);
                              }

                              return TabBarView(
                                children: [
                                  DepartmentsProfitability(
                                    salesDepartments: salesDepartments,
                                  ),
                                  Sections(saleStatistics: salesDepartments),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
