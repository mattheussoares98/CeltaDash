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
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final home = Get.find<HomePresenter>();
        Get.find<DepartmentsPresenter>().getSales(home);
      }
    });
  }

  @override
  void dispose() {
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();
    final departmentsPresenter = Get.find<DepartmentsPresenter>();

    // handle errors
    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, departmentsPresenter.mainErrorStream);

    return StreamBuilder<bool>(
      stream: departmentsPresenter.isLoadingStream,
      builder: (context, loadingSnap) {
        final isLoading = loadingSnap.data == true;

        return Scaffold(
          appBar: DefaultAppBar(
            isLoading: isLoading,
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
          body: SafeArea(
            left: false,
            right: false,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SelectPeriodItems(
                        isLoading: isLoading,
                        selectedPeriodType: departmentsPresenter.selectedPeriod,
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
                    ],
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
                      final daily = departmentsPresenter.dailyStatistics
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterDay: homePresenter.selectedDate.day,
                            filterMonth: homePresenter.selectedDate.month,
                            filterYear: homePresenter.selectedDate.year,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final monthly = departmentsPresenter.monthlyStatistics
                          ?.filteredSales(
                            enterprise: homePresenter.selectedEnterprise,
                            filterMonth: homePresenter.selectedDate.month,
                          )
                          .map((e) => e.toViewModel())
                          .toList();

                      final sales = departmentsPresenter.selectedPeriod ==
                              PeriodType.daily
                          ? daily
                          : monthly;

                      if (sales == null || sales.isEmpty) {
                        return EmptySales(isLoading: isLoading);
                      }

                      return TabBarView(
                        children: [
                          Departments(saleStatistics: sales),
                          Sections(saleStatistics: sales),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
