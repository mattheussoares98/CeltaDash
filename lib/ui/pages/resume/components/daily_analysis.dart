import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class DailyAnalysis extends StatelessWidget {
  final ScrollController scrollController;
  final List<SaleStatisticViewModel> saleStatistics;
  const DailyAnalysis({
    super.key,
    required this.saleStatistics,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    final now = DateTime.now();

    final filteredSales = saleStatistics.filteredSales(
      enterprise: homePresenter.selectedEnterprise,
      filterYear: now.year,
    );

    if (filteredSales.isEmpty) return Container();

    final betterAverage = saleStatistics.hourAverage(
      getBest: true,
      enterprise: homePresenter.selectedEnterprise,
      filterYear: now.year,
    );
    final worstAverage = saleStatistics.hourAverage(
      getBest: false,
      enterprise: homePresenter.selectedEnterprise,
      filterYear: now.year,
    );

    return Column(
      children: [
        SalesInformations(
          title: R.string.dailyAnalysisAverage,
          totalSales: saleStatistics.weekDayAverage(
            homePresenter.selectedEnterprise,
          ),
          goal: 0,
          scrollController: scrollController,
          topChildren: [
            Text(
              "${R.string.all} ${DateFormat.EEEE('pt_BR').format(now)}s ${R.string.of.toLowerCase()} ${homePresenter.selectedDate.year}",
              textAlign: TextAlign.center,
            ),
            CompareTimesResult(
              betterTime: betterAverage.hour,
              betterValue: betterAverage.value,
              worstTime: worstAverage.hour,
              worstValue: worstAverage.value,
              betterTimeMessage: R.string.bestHourOfTheDay,
              worstTimeMessage: R.string.worstHourOfTheDay,
            ),
          ],
        ),
      ],
    );
  }
}
