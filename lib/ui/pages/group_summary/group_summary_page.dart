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
              await resumePresenter.getSales(homePresenter);
            },
            onChangeEnterprise: (_) async {
              await resumePresenter.getSales(homePresenter);
            },
            onTapRefresh: () async {
              await resumePresenter.getSales(homePresenter, forceRefresh: true);
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: SelectPeriodItems(
                  isLoading: loadingSnap.data,
                  selectedPeriodType: resumePresenter.selectedPeriodValue,
                  onTapDaily: () {
                    resumePresenter.getSales(
                      homePresenter,
                      periodType: PeriodType.daily,
                    );
                  },
                  onTapMonthly: () {
                    resumePresenter.getSales(
                      homePresenter,
                      periodType: PeriodType.monthly,
                    );
                  },
                ),
              ),
              Obx(() {
                final saleStatistics = resumePresenter.saleStatistics;
        
                if (saleStatistics == null || saleStatistics.isEmpty) {
                  return EmptySales(isLoading: false);
                }
        
                final groupSales = saleStatistics
                    .filteredSales(
                      filterDay:
                          resumePresenter.selectedPeriodValue == PeriodType.daily
                              ? homePresenter.selectedDate.day
                              : null,
                    )
                    .map((e) => e.toViewModel())
                    .toList();
        
                final groupSalesTotalLiquid = groupSales.sumLiquidValue();
                int groupSalesQuantity = groupSales.quantitySales();
        
                return Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
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
                  ),
                );
              }),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            items: [
              BottomNavItem(
                materialIcon: Icon(Icons.bar_chart_rounded),
                cupertinoIcon: Icon(CupertinoIcons.list_dash),
                label: R.string.details,
              ),
              BottomNavItem(
                materialIcon: Icon(Icons.pie_chart),
                cupertinoIcon: Icon(CupertinoIcons.chart_pie),
                label: R.string.resume,
              ),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
              if (pageController.hasClients) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        );
      }
    );
  }
}
