import 'package:celta_plus/ui/pages/group_summary/group_summary_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';
import 'group_summary_resume_page.dart';

class GroupSummaryPage extends StatefulWidget {
  const GroupSummaryPage({super.key});

  @override
  State<GroupSummaryPage> createState() => _GroupSummaryPageState();
}

class _GroupSummaryPageState extends State<GroupSummaryPage> {
  bool selectedDay = true;
  final pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  bool needUpdatePage = false;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    return Scaffold(
      appBar: DefaultAppBar(
        showEnterpriseDropdown: false,
        onChangeDate: (newDate) {
          Future.delayed(Duration.zero, () {
            setState(() {
              needUpdatePage = true;
            });
          });
        },
        onChangeEnterprise: (changedEnterprise) async {
          await resumePresenter.getSales(
            homePresenter,
            forceRefresh: !changedEnterprise,
          );
          Future.delayed(Duration.zero, () {
            setState(() {
              needUpdatePage = true;
            });
          });
        },
        onTapRefresh: () async {
          await resumePresenter.getSales(homePresenter, forceRefresh: true);
          Future.delayed(Duration.zero, () {
            setState(() {
              needUpdatePage = true;
            });
          });
        },
      ),
      body: Obx(() {
        final saleMovements = resumePresenter.saleMovements;

        if (saleMovements == null || saleMovements.isEmpty) {
          return NoSalesWereFound();
        }

        if (needUpdatePage) {
          Future.delayed(Duration.zero, () {
            setState(() {
              needUpdatePage = false;
            });
          });
        }

        final groupSales = saleMovements
            .filteredSales(
              filterDay: selectedDay ? homePresenter.selectedDate.day : null,
            )
            .map((e) => e.toViewModel())
            .toList();

        final groupSalesTotalLiquid = groupSales.sumLiquidValue();
        int groupSalesQuantity = groupSales.quantitySales();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: SelectDayOrMonthItems(change: (value) {
                Future.delayed(Duration.zero, () {
                  setState(() {
                    needUpdatePage = true;
                    selectedDay = value;
                  });
                });
              }),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  GroupSummaryDetailsPage(
                    groupSalesTotalLiquid: groupSalesTotalLiquid,
                    selectedDay: selectedDay,
                    saleMovements: saleMovements,
                  ),
                  GroupSummaryResumePage(
                    groupSalesTotalLiquid: groupSalesTotalLiquid,
                    groupSales: groupSales,
                    groupSalesQuantity: groupSalesQuantity,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomBar(
        onChangePage: (index) {
          Future.delayed(Duration.zero, () {
            setState(() {
              needUpdatePage = true;
              currentIndex = index;
            });
          });
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        currentIndex: currentIndex,
      ),
    );
  }
}
