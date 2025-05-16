import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage>
    with LoadingManager, UIErrorManager {
  bool selectedMonth = false;
  int selectedPageIndex = 0;
  // StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    pageController.dispose();
  }

  void updateSelectedMonth(bool value) {
    setState(() {
      selectedMonth = value;
    });
  }

  bool filter(SaleMovementViewModel sale, HomePresenter homePresenter) {
    final selectedDate = homePresenter.selectedDate;

    return (selectedMonth ? true : sale.Date?.day == selectedDate.day) &&
        sale.Date?.month == selectedDate.month &&
        sale.Date?.year == selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    DepartmentsPresenter departmentsPresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    PaymentTypePresenter paymentTypePresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();

    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    // loadingSubscription =
    //     handleLoading(context, departmentsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, departmentsPresenter.mainErrorStream);

    return StreamBuilder<bool>(
        stream: departmentsPresenter.isLoadingStream,
        builder: (context, isLoadingDepartments) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: isLoadingDepartments.data == true,
              onChangeEnterprise: (_) async {
                homePresenter.reloadAllData(
                  salesPresenter,
                  resumePresenter,
                  paymentTypePresenter,
                  productsPresenter,
                  departmentsPresenter,
                );
              },
              onChangeDate: (_) async {
                homePresenter.reloadAllData(
                  salesPresenter,
                  resumePresenter,
                  paymentTypePresenter,
                  productsPresenter,
                  departmentsPresenter,
                );
              },
              onTapRefresh: () async {
                homePresenter.reloadAllData(
                  salesPresenter,
                  resumePresenter,
                  paymentTypePresenter,
                  productsPresenter,
                  departmentsPresenter,
                  forceRefresh: true,
                );
              },
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final saleMovements = departmentsPresenter.saleMovements
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel())
                      .where((e) => filter(e, homePresenter))
                      .toList();

                  if (saleMovements == null || saleMovements.isEmpty) {
                    return SizedBox.shrink();
                  }

                  return StreamBuilder<bool>(
                      stream: homePresenter.updateScreenStream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectDayOrMonth(
                                  updateSelectedMonth: updateSelectedMonth),
                            ),
                            Expanded(
                              child: Opacity(
                                opacity: snapshot.data == true ? 0 : 1,
                                child: PageView(
                                  controller: pageController,
                                  onPageChanged: (value) {
                                    setState(() {
                                      selectedPageIndex = value;
                                    });
                                  },
                                  children: [
                                    Departments(saleMovements: saleMovements),
                                    Sections(saleMovements: saleMovements),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }),
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: selectedPageIndex,
              showLabels: true,
              onTap: (value) {
                setState(() {
                  selectedPageIndex = value;
                });
                if (pageController.hasClients) {
                  pageController.animateToPage(
                    value,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.bounceOut,
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
  }
}
