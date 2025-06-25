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

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();

    // resumeLoadingSubscription = handleLoading(
    //   context,
    //   resumePresenter.isLoadingStream,
    // );
    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, resumePresenter.mainErrorStream);

    return StreamBuilder(
        stream: resumePresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  now: DateTime.now(),
                );
              },
              onChangeDate: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  now: DateTime.now(),
                );
              },
              onTapRefresh: () {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  forceRefresh: true,
                  now: DateTime.now(),
                );
              },
            ),
            body: SingleChildScrollView(
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
                    return EmptySales(isLoading: loadingSnap.data == true);
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
                          SizedBox(height: 8),
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
                          SizedBox(height: 8),
                        ],
                      ),
                      GroupOfStores(sales: sales),
                      SizedBox(height: 15),
                    ],
                  );
                }),
              ),
            ),
          );
        });
  }
}
