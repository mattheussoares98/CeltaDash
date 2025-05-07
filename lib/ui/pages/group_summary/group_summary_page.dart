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
        onChangeDate: (newDate) {},
        onChangeEnterprise: (changedEnterprise) async {
          await resumePresenter.getSales(
            homePresenter,
            forceRefresh: !changedEnterprise,
          );
        },
        onTapRefresh: () async {
          await resumePresenter.getSales(homePresenter, forceRefresh: true);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: SelectDayOrMonthItems(change: (value) {
              setState(() {
                selectedDay = value;
              });
            }),
          ),
          Obx(() {
            final saleMovements = resumePresenter.saleMovements;

            if (saleMovements == null || saleMovements.isEmpty) {
              return NoSalesWereFound();
            }

            final groupSales = saleMovements
                .filteredSales(
                  filterDay:
                      selectedDay ? homePresenter.selectedDate.day : null,
                )
                .map((e) => e.toViewModel())
                .toList();

            final groupSalesTotalLiquid = groupSales.sumLiquidValue();
            int groupSalesQuantity = groupSales.quantitySales();

            return StreamBuilder<bool>(
                stream: homePresenter.updateScreenStream,
                builder: (context, snapshot) {
                  return Expanded(
                    child: Opacity(
                      opacity: snapshot.data == true ? 0 : 1,
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
                  );
                });
          }),
        ],
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
        currentIndex: currentIndex,
      ),
    );
  }
}
