import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'group_summary_details_page.dart';
import 'group_summary_resume_page.dart';

class GroupSummaryPage extends StatefulWidget {
  const GroupSummaryPage({super.key});

  @override
  State<GroupSummaryPage> createState() => _GroupSummaryPageState();
}

class _GroupSummaryPageState extends State<GroupSummaryPage> {
  final pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    return StreamBuilder(
        stream: resumePresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              showEnterpriseDropdown: false,
              onChangeDate: (newDate) async {
                await resumePresenter.getSales(
                  homePresenter,
                  now: DateTime.now(),
                );
              },
              onChangeEnterprise: (_) async {
                await resumePresenter.getSales(
                  homePresenter,
                  now: DateTime.now(),
                );
              },
              onTapRefresh: () async {
                await resumePresenter.getSales(
                  homePresenter,
                  forceRefresh: true,
                  now: DateTime.now(),
                );
              },
            ),
            body: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SelectPeriodItems(
                        isLoading: loadingSnap.data,
                        selectedPeriodType: resumePresenter.selectedPeriod,
                        onTapDaily: () {
                          resumePresenter.getSales(
                            homePresenter,
                            periodType: PeriodType.daily,
                            now: DateTime.now(),
                          );
                        },
                        onTapMonthly: () {
                          resumePresenter.getSales(
                            homePresenter,
                            periodType: PeriodType.monthly,
                            now: DateTime.now(),
                          );
                        },
                      ),
                    ),
                    DefaultTabBar(
                      tabs: [
                        DefaultTab(
                          title: R.string.details,
                          materialIcon: Icons.bar_chart_rounded,
                          cupertinoIcon: CupertinoIcons.list_dash,
                        ),
                        DefaultTab(
                          title: R.string.resume,
                          materialIcon: Icons.pie_chart,
                          cupertinoIcon: CupertinoIcons.chart_pie,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(() {
                        final saleStatistics = resumePresenter.saleStatistics;
                      
                        if (saleStatistics == null || saleStatistics.isEmpty) {
                          return EmptySales(isLoading: false);
                        }
                      
                        final groupSales = saleStatistics
                            .filteredSales(
                              filterDay: resumePresenter.selectedPeriod ==
                                      PeriodType.daily
                                  ? homePresenter.selectedDate.day
                                  : null,
                            )
                            .map((e) => e.toViewModel())
                            .toList();
                      
                        final groupSalesTotalLiquid = groupSales.sumLiquidValue();
                        int groupSalesQuantity = groupSales.quantitySales();
                      
                        return TabBarView(
                          children: [
                            GroupSummaryDetailsPage(
                              groupSalesTotalLiquid: groupSalesTotalLiquid,
                              saleStatistics: saleStatistics,
                            ),
                            GroupSummaryResumePage(
                              groupSalesTotalLiquid: groupSalesTotalLiquid,
                              groupSales: groupSales,
                              groupSalesQuantity: groupSalesQuantity,
                            ),
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
  }
}
