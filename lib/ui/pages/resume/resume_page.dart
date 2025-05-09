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
    with UIErrorManager, LoadingManager, RouteAware {
  final scrollController = ScrollController();
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;

  @override
  void dispose() {
    super.dispose();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);

    scrollController.dispose();

    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
    loadingSubscription = handleLoading(
      context,
      resumePresenter.isLoadingStream,
    );
    mainErrorSubscription = handleMainError(
      context,
      resumePresenter.mainErrorStream,
    );

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeEnterprise: (changedEnterprise) async {
          await resumePresenter.getSales(homePresenter);
        },
        onChangeDate: (newDate) async {
          await resumePresenter.getSales(homePresenter);
        },
        onTapRefresh: () async {
          await resumePresenter.getSales(homePresenter, forceRefresh: true);
        },
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Obx(() {
            final saleMovements = resumePresenter.saleMovements;

            if (saleMovements == null) {
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await resumePresenter.getSales(homePresenter);
                      },
                      child: Text(R.string.searchAgain),
                    ),
                  ),
                ],
              );
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
