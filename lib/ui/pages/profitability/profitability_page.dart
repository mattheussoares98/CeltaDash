import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class ProfitabilityPage extends StatefulWidget {
  const ProfitabilityPage({super.key});

  @override
  State<ProfitabilityPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<ProfitabilityPage> {
  int selectedPageIndex = 0;
  final pageController = PageController();

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
  Widget build(BuildContext context) {
    DepartmentsPresenter departmentsPresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

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
                  body: Column(
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
                      Obx(() {
                        final salesDepartments =
                            departmentsPresenter.saleStatistics
                                ?.filteredSales(
                                  enterprise: homePresenter.selectedEnterprise,
                                  filterDay: departmentsPresenter
                                              .selectedPeriod ==
                                          PeriodType.daily
                                      ? homePresenter.selectedDate.day
                                      : null,
                                  filterMonth: homePresenter.selectedDate.month,
                                  filterYear: homePresenter.selectedDate.year,
                                )
                                .map((e) => e.toViewModel())
                                .toList();

                        if (salesDepartments == null ||
                            salesDepartments.isEmpty) {
                          return EmptySales(
                              isLoading: loadingDepartmentsSnap.data == true ||
                                  loadingProductsSnap.data == true);
                        }
                        return Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: PageView(
                                  controller: pageController,
                                  onPageChanged: (value) {
                                    setState(() {
                                      selectedPageIndex = value;
                                    });
                                  },
                                  children: [
                                    DepartmentsProfitability(
                                      salesDepartments: salesDepartments,
                                    ),
                                    Sections(
                                      saleStatistics: salesDepartments,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  bottomNavigationBar: BottomNavBar(
                    currentIndex: selectedPageIndex,
                    onTap: (value) {
                      setState(() {
                        selectedPageIndex = value;
                      });
                      if (pageController.hasClients) {
                        pageController.animateToPage(
                          value,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    items: [
                      BottomNavItem(
                        materialIcon: Icon(Icons.apartment),
                        cupertinoIcon: Icon(CupertinoIcons.building_2_fill),
                        label: R.string.departments,
                      ),
                      BottomNavItem(
                        materialIcon: Icon(Icons.view_module),
                        cupertinoIcon: Icon(CupertinoIcons.square_grid_2x2),
                        label: R.string.sections,
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
