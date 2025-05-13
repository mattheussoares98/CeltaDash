import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void dispose() {
    super.dispose();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);

    scrollController.dispose();
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

    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Obx(() {
            final saleMovements = resumePresenter.saleMovements;

            if (saleMovements == null) {
              return SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
