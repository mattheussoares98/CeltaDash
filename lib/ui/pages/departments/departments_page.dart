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

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage>
    with LoadingManager, UIErrorManager {
  int selectedPageIndex = 0;
  StreamSubscription? mainErrorSubscription;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        DepartmentsPresenter departmentsPresenter = Get.find();
        departmentsPresenter.getSales(Get.find<HomePresenter>());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    DepartmentsPresenter departmentsPresenter = Get.find();

    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, departmentsPresenter.mainErrorStream);

    return StreamBuilder<bool>(
        stream: departmentsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                departmentsPresenter.getSales(homePresenter);
              },
              onChangeDate: (_) {
                departmentsPresenter.getSales(homePresenter);
              },
              onTapRefresh: () {
                departmentsPresenter.getSales(
                  homePresenter,
                  forceRefresh: true,
                );
              },
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectPeriodItems(
                    isLoading: loadingSnap.data,
                    selectedPeriodType:
                        departmentsPresenter.selectedPeriodValue,
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
                  final saleStatistics = departmentsPresenter.saleStatistics
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                        filterDay: departmentsPresenter.selectedPeriodValue ==
                                PeriodType.daily
                            ? homePresenter.selectedDate.day
                            : null,
                        filterMonth: homePresenter.selectedDate.month,
                        filterYear: homePresenter.selectedDate.year,
                      )
                      .map((e) => e.toViewModel())
                      .toList();

                  if (saleStatistics == null || saleStatistics.isEmpty) {
                    return EmptySales(isLoading: loadingSnap.data);
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
                              Departments(saleStatistics: saleStatistics),
                              Sections(saleStatistics: saleStatistics),
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
  }
}
