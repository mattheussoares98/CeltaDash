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
        onChangeEnterprise: (changedEnterprise) async {
          await resumePresenter.getSales(
            homePresenter,
            forceRefresh: !changedEnterprise,
          );
        },
        onTapRefresh: () {
          resumePresenter.getSales(homePresenter, forceRefresh: true);
        },
      ),
      bottomNavigationBar: BottomBar(
          onChangePage: (index) {
            setState(() {
              currentIndex = index;
            });
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          currentIndex: currentIndex),
      body: Obx(() {
        final saleMovements = resumePresenter.saleMovements;

        if (saleMovements == null || saleMovements.isEmpty) {
          return NoSalesWereFound();
        }

        final groupSales = saleMovements
            .filteredSales(
              filterDay: selectedDay ? homePresenter.selectedDate.day : null,
            )
            .map((e) => e.toViewModel())
            .toList();

        final groupSalesTotalLiquid = groupSales.sumLiquidValue();
        int groupSalesQuantity = groupSales.quantitySales();

        return PageView(
          controller: pageController,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text("Group Summary"),
                    )
                  ],
                ),
              ),
            ),
            GroupSummaryResumePage(
              changeDayOrMonth: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              groupSalesTotalLiquid: groupSalesTotalLiquid,
              groupSales: groupSales,
              groupSalesQuantity: groupSalesQuantity,
            ),
          ],
        );
      }),
    );
  }
}
