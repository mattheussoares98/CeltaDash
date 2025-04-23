import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/models.dart';
import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class ResumePage extends StatefulWidget {
  final ResumePresenter resumePresenter;
  const ResumePage({super.key, required this.resumePresenter});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage>
    with UIErrorManager, LoadingManager {
  final scrollController = ScrollController();
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Provider.of(context, listen: false);
        await widget.resumePresenter.getSales(homePresenter);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();

    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
  }

  final DailySalesModel dailySalesModel = DailySalesModel(
    salesQuantity: Random().nextInt(1000),
    totalAmountInDay: Random().nextDouble() * 50000,
    productsAverageBySale: Random().nextDouble() * 10,
  );

  final quantityOfDaysInMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, widget.resumePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.resumePresenter.mainErrorStream);

    double totalMonthSales =
        Random().nextDouble() * 50000 * quantityOfDaysInMonth;
    double totalDaySales = totalMonthSales / quantityOfDaysInMonth;

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: () {
          debugPrint("Search all resume data again");
        },
      ),
      body: ListenableProvider(
        create: (_) => widget.resumePresenter,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SalesInformations(
                  scrollController: scrollController,
                  title: R.string.salesOfTheDay,
                  totalSales: totalDaySales * Random().nextDouble(),
                  goal: totalDaySales,
                  leftButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToPaymentsTypePage,
                    title: R.string.paymentsType,
                  ),
                  rightButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToSectionsPage,
                    title: R.string.sections,
                  ),
                  children: [
                    Text(
                      "${R.string.salesQuantity}\n${dailySalesModel.salesQuantity}",
                    ),
                    Text(
                      "${R.string.ticketAverage}\n${(dailySalesModel.totalAmountInDay / dailySalesModel.salesQuantity).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                    Text(
                      "${R.string.productsBySale}\n${dailySalesModel.productsAverageBySale.toString().toBrazilianNumber()}",
                    ),
                    Text(
                      "${R.string.averagePrice}\n${(dailySalesModel.totalAmountInDay / dailySalesModel.salesQuantity / dailySalesModel.productsAverageBySale).toString().toBrazilianNumber().addBrazilianCoin()}",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SalesInformations(
                  scrollController: scrollController,
                  goal: totalMonthSales,
                  totalSales: totalMonthSales * Random().nextDouble(),
                  title: R.string.salesOfTheMonth,
                  leftButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToSetGoalPage,
                    title: R.string.insertGoal,
                  ),
                  rightButton: DefaultNavigateButton(
                    onTap: widget.resumePresenter.goToGoalHistoryPage,
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
                  onTap: widget.resumePresenter.goToProfitabillityPage,
                  title: R.string.profitability,
                  icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
                ),
                const SizedBox(height: 8),
                DailyAnalysis(),
                SizedBox(height: 8),
                MonthlyAnalysis(),
                SizedBox(height: 8),
                DefaultNavigateButton(
                  onTap: widget.resumePresenter.goToGroupSummaryPage,
                  title: R.string.groupSummary,
                  icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
                ),
                SizedBox(height: 8),
                GroupOfStores(),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
