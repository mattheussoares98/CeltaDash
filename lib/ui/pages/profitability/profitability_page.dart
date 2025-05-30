import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool selectedDay = true;
  int selectedPageIndex = 0;
  final pageController = PageController();

  Future<void> reloadData({
    bool? forceRefresh,
  }) async {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    PaymentTypePresenter paymentTypePresenter = Get.find();
    DepartmentsPresenter departmentsPresenter = Get.find();
    OperatorsPresenter operatorsPresenter = Get.find();
    SellersPresenter sellersPresenter = Get.find();

    homePresenter.reloadAllData(
      salesPresenter,
      resumePresenter,
      paymentTypePresenter,
      productsPresenter,
      departmentsPresenter,
      operatorsPresenter,
      sellersPresenter,
      forceRefresh: forceRefresh,
    );
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        final salesDepartments =
                            departmentsPresenter.saleMovements
                                ?.filteredSales(
                                  enterprise: homePresenter.selectedEnterprise,
                                  filterDay: selectedDay
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
                        return StreamBuilder(
                            stream: homePresenter.updateScreenStream,
                            builder: (context, updateScreen) {
                              return Expanded(
                                child: Column(
                                  children: [
                                    Periods(
                                      selectedDay: selectedDay,
                                      selectDay: () {
                                        setState(() {
                                          selectedDay = true;
                                        });
                                      },
                                      selectMonth: () {
                                        setState(() {
                                          selectedDay = false;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Opacity(
                                        opacity:
                                            updateScreen.data == true ? 0 : 1,
                                        child: PageView(
                                          controller: pageController,
                                          onPageChanged: (value) {
                                            setState(() {
                                              selectedPageIndex = value;
                                            });
                                          },
                                          children: [
                                            DepartmentsProfitability(
                                              salesDepartments:
                                                  salesDepartments,
                                            ),
                                            Sections(
                                              saleMovements: salesDepartments,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
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
