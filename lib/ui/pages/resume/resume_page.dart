import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
    final resumePresenter =
        Provider.of<ResumePresenter>(context, listen: false);
    final homePresenter = Provider.of<HomePresenter>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) async => await resumePresenter.getSales(homePresenter));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
        onChangeDateOrEnterprise: () async {
          await resumePresenter.getSales(homePresenter, forceRefresh: true);
          setState(() {});
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
                SalesInformations(
                  scrollController: scrollController,
                  title: R.string.salesOfTheDay,
                  totalSales: saleMovements.sumLiquidValue(
                    enterprise: homePresenter.selectedEnterprise,
                    filterDate: homePresenter.selectedDate,
                  ),
                  goal: 100000,
                  leftButton: DefaultNavigateButton(
                    onTap: resumePresenter.goToPaymentsTypePage,
                    title: R.string.paymentsType,
                  ),
                  rightButton: DefaultNavigateButton(
                    onTap: resumePresenter.goToDepartmentsPage,
                    title: R.string.departments,
                  ),
                  children: [
                    Text(
                      "${R.string.salesQuantity}\n${saleMovements.quantitySales(
                        enterprise: homePresenter.selectedEnterprise,
                        filterDate: homePresenter.selectedDate,
                      )}",
                    ),
                    Text(
                      "${R.string.ticketAverage}\n${(saleMovements.ticketAverage(
                        enterprise: homePresenter.selectedEnterprise,
                        filterDate: homePresenter.selectedDate,
                      )).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                    Text(
                      //TODO
                      "Request Cardoso to add products by sale quantity and average price",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SalesInformations(
                  scrollController: scrollController,
                  goal: 10000,
                  totalSales: 10000 * Random().nextDouble(),
                  title: R.string.salesOfTheMonth,
                  leftButton: DefaultNavigateButton(
                    onTap: resumePresenter.goToSetGoalPage,
                    title: R.string.insertGoal,
                  ),
                  rightButton: DefaultNavigateButton(
                    onTap: resumePresenter.goToGoalHistoryPage,
                    title: R.string.goalHistory,
                  ),
                  children: [
                    Text(
                      "${R.string.salesUntilNow}\n${(Random().nextDouble() * 30000).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DefaultNavigateButton(
                  onTap: resumePresenter.goToProfitabillityPage,
                  title: R.string.profitability,
                  icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
                ),
                const SizedBox(height: 8),
                DailyAnalysis(),
                SizedBox(height: 8),
                MonthlyAnalysis(),
                SizedBox(height: 8),
                DefaultNavigateButton(
                  onTap: resumePresenter.goToGroupSummaryPage,
                  title: R.string.groupSummary,
                  icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
                ),
                SizedBox(height: 8),
                GroupOfStores(),
                SizedBox(height: 15),
              ],
            );
          }),
        ),
      ),
    );
  }
}
