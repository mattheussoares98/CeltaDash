import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage>
    with UIErrorManager, LoadingManager {
  final scrollController = ScrollController();
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
    mainErrorSubscription?.cancel();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final resumePresenter = Get.find<ResumePresenter>();
  //     final homePresenter = Get.find<HomePresenter>();
  //     await resumePresenter.getSales(homePresenter, now: DateTime.now());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();

    // resumeLoadingSubscription = handleLoading(
    //   context,
    //   resumePresenter.isLoadingStream,
    // );
    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, resumePresenter.mainErrorStream);

    return Obx(() {
      final enterpriseIsEnabled = homePresenter.selectedEnterpriseIsEnabled;

      return StreamBuilder(
          stream: resumePresenter.isLoadingStream,
          builder: (context, loadingSnap) {
            return Scaffold(
              appBar: DefaultAppBar(
                showEnterpriseManagerButton: true,
                isLoading: loadingSnap.data == true,
                showDatePicker: enterpriseIsEnabled,
                onChangeEnterprise: (_) {
                  resumePresenter.getSales(homePresenter, now: DateTime.now());
                },
                onChangeDate: (_) {
                  resumePresenter.getSales(homePresenter, now: DateTime.now());
                },
                onTapRefresh: () {
                  resumePresenter.getSales(
                    homePresenter,
                    now: DateTime.now(),
                    forceRefresh: true,
                  );
                },
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                      child: Obx(() {
                        final sales = resumePresenter.saleStatistics;
                        final salesByEnterprise = resumePresenter.saleStatistics
                            ?.filteredSales(
                              enterprise: homePresenter.selectedEnterprise,
                            )
                            .map((e) => e.toViewModel())
                            .toList();

                        if (sales == null ||
                            sales.isEmpty ||
                            salesByEnterprise == null) {
                          return EmptySales(
                              isLoading: loadingSnap.data == true);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                DailyStatistics(
                                  scrollController: scrollController,
                                  saleStatistics: salesByEnterprise,
                                ),
                                const SizedBox(height: 8),
                                MonthlyAnalysis(sales: salesByEnterprise),
                                // const SizedBox(height: 8),
                                // SalesInformations(
                                //   scrollController: scrollController,
                                //   totalSales: saleStatistics.sumLiquidValue(
                                //     enterprise: homePresenter.selectedEnterprise,
                                //     filterYear: homePresenter.selectedDate.year,
                                //     filterMonth: homePresenter.selectedDate.month,
                                //   ),
                                //   title: R.string.salesOfTheMonth,
                                // ),
                                // const SizedBox(height: 8),
                                // DefaultNavigateButton(
                                //   onTap: resumePresenter.goToProfitabillityPage,
                                //   title: R.string.profitability,
                                //
                                // const SizedBox(height: 8),
                                // DailyAnalysis(
                                //   saleStatistics: saleStatistics,
                                //   scrollController: scrollController,
                                // ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            if (sales
                                    .map((e) => e.EnterpriseId)
                                    .toSet()
                                    .length >
                                1)
                              GroupOfStores(sales: sales),
                            const SizedBox(height: 15),
                          ],
                        );
                      }),
                    ),
                  ),
                  if (enterpriseIsEnabled == false)
                    const Positioned(
                      // Start after the status bar and the AppBar
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: DisabledEnterpriseBlur(),
                    ),
                ],
              ),
            );
          });
    });
  }
}
