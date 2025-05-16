import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage>
    with UIErrorManager, LoadingManager, RouteAware {
  final scrollController = ScrollController();
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);

    scrollController.dispose();
    mainErrorSubscription?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    debugPrint('Closed another page and returned to resumePage');
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) async => await resumePresenter.getSales(homePresenter));
  }

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    // resumeLoadingSubscription = handleLoading(
    //   context,
    //   resumePresenter.isLoadingStream,
    // );
    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, resumePresenter.mainErrorStream);

    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Obx(() {
            final saleMovements = resumePresenter.saleMovements;
            final salesByEnterprise = saleMovements
                ?.filteredSales(
                  enterprise: homePresenter.selectedEnterprise,
                )
                .map((e) => e.toViewModel())
                .toList();

            if (saleMovements == null) {
              return SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (salesByEnterprise == null || salesByEnterprise.isEmpty)
                  Image.asset("lib/ui/assets/images/empty_sales.png"),
                if (salesByEnterprise != null && salesByEnterprise.isNotEmpty)
                  Column(
                    children: [
                      DailySales(
                        scrollController: scrollController,
                        saleMovements: saleMovements,
                      ),
                      SizedBox(height: 8),
                      MonthlyAnalysis(saleMovements: saleMovements),
                      // const SizedBox(height: 8),
                      // SalesInformations(
                      //   scrollController: scrollController,
                      //   totalSales: saleMovements.sumLiquidValue(
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
                      //   saleMovements: saleMovements,
                      //   scrollController: scrollController,
                      // ),
                      SizedBox(height: 8),
                    ],
                  ),
                GroupOfStores(saleMovements: saleMovements),
                SizedBox(height: 15),
              ],
            );
          }),
        ),
      ),
    );
  }
}
