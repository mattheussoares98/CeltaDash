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
        departmentsPresenter.emitLoadingAgain();
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
        builder: (context, isLoadingDepartments) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: isLoadingDepartments.data == true,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final saleMovements = departmentsPresenter.saleMovements
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                        filterDay: departmentsPresenter.selectedPeriodType ==
                                PeriodType.daily
                            ? homePresenter.selectedDate.day
                            : null,
                        filterMonth: homePresenter.selectedDate.month,
                        filterYear: homePresenter.selectedDate.year,
                      )
                      .map((e) => e.toViewModel())
                      .toList();

                  if (saleMovements == null || saleMovements.isEmpty) {
                    return EmptySales(isLoading: isLoadingDepartments.data);
                  }

                  return StreamBuilder<bool>(
                      stream: homePresenter.updateScreenStream,
                      builder: (context, snapshot) {
                        return Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectPeriodItems(
                                  selectedPeriodType:
                                      departmentsPresenter.selectedPeriodType,
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
  }
}
