import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class DailyStatistics extends StatelessWidget {
  final ScrollController scrollController;
  final List<SaleStatisticViewModel> saleStatistics;
  const DailyStatistics({
    super.key,
    required this.scrollController,
    required this.saleStatistics,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();

    final now = DateTime.now();
    bool isCurrentDay = now.day == homePresenter.selectedDate.day &&
        now.month == homePresenter.selectedDate.month &&
        now.year == homePresenter.selectedDate.year;

    final selectedDayStatistics = resumePresenter.compareDaysStatistics
        ?.filteredSales(
          enterprise: homePresenter.selectedEnterprise,
          filterYear: homePresenter.selectedDate.year,
          filterMonth: homePresenter.selectedDate.month,
          filterDay: homePresenter.selectedDate.day,
        )
        .where((e) {
          if (e.Date == null) {
            return false;
          } else if (isCurrentDay) {
            return e.Hour! <= now.hour && e.Date!.year == now.year;
          } else {
            return e.Date!.year == now.year;
          }
        })
        .map((e) => e.toViewModel())
        .toList();

    final previousMonthStatistics = resumePresenter.compareDaysStatistics
        ?.filteredSales(
          enterprise: homePresenter.selectedEnterprise,
          filterYear: homePresenter.selectedDate.year,
        )
        .where((e) {
          if (e.Date == null) {
            return false;
          } else if (isCurrentDay) {
            return e.Hour! <= now.hour &&
                e.Date?.month != now.month &&
                e.Date!.year == now.year;
          } else {
            return e.Date?.month != now.month && e.Date!.year == now.year;
          }
        })
        .map((e) => e.toViewModel())
        .toList();

    final selectedDayLiquidValue = selectedDayStatistics?.sumLiquidValue() ?? 1;
    final previousMonthLiquidValue =
        previousMonthStatistics?.sumLiquidValue() ?? 0;

    final percentageResult =
        (selectedDayLiquidValue / previousMonthLiquidValue * 100 - 100);

    return Container(
      decoration: ContainerDecoration.decoration,
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(
            R.string.salesOfTheDay.toUpperCase(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          ChartPieWidget(
            showTotalAmount: false,
            centerSpaceRadius: 50,
            centerDate: homePresenter.selectedDate,
            centerPassedColor: Colors.grey[350]!,
            centerRemainingColor: Colors.white,
            pieParameters: [
              PieParameter(
                title: Title(
                  isCurrentDay: isCurrentDay,
                  now: now,
                  isPreviousMonth: false,
                  statistics: selectedDayStatistics ?? [],
                  color: percentageResult >= 0 ? Colors.green : Colors.red,
                ),
                color: percentageResult >= 0 ? Colors.green : Colors.red,
                subtitle: SubTitle(
                  statistics: selectedDayStatistics ?? [],
                ),
                value: selectedDayLiquidValue,
              ),
              PieParameter(
                title: Title(
                  isCurrentDay: isCurrentDay,
                  now: now,
                  isPreviousMonth: true,
                  statistics: previousMonthStatistics ?? [],
                  color: Colors.orange,
                ),
                color: Colors.orange,
                subtitle: SubTitle(
                  statistics: previousMonthStatistics ?? [],
                ),
                showSubtitleOnlyOnTap: true,
                value: previousMonthLiquidValue,
              ),
            ],
          ),
          Text(
            "${percentageResult.toStringAsFixed(2).toBrazilianNumber()}%",
            style: TextStyle(
              color: percentageResult >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final List<SaleStatisticViewModel> statistics;
  const SubTitle({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();

    String subtitle = "";

    if (statistics.isEmpty) {
      return Text(subtitle);
    }
    double totalTickets = statistics
        .quantitySales(enterprise: homePresenter.selectedEnterprise)
        .toDouble();

    subtitle +=
        "${R.string.customers}: ${totalTickets.toString().toBrazilianNumber(0)}";
    subtitle +=
        "\n${R.string.average}: ${statistics.ticketAverage(homePresenter.selectedEnterprise).toString().toBrazilianNumber().addBrazilianCoin()}";

    return Text(
      subtitle,
      style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
    );
  }
}

class Title extends StatelessWidget {
  final bool isCurrentDay;
  final DateTime now;
  final bool isPreviousMonth;
  final List<SaleStatisticViewModel> statistics;
  final Color color;
  const Title({
    super.key,
    required this.isCurrentDay,
    required this.now,
    required this.isPreviousMonth,
    required this.statistics,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();
    double totalValue = statistics.sumLiquidValue();
    "${R.string.sales}: ${totalValue.toString().toBrazilianNumber().addBrazilianCoin()}";

    final previowsDate = DateTime(
      homePresenter.selectedDate.year,
      homePresenter.selectedDate.month - 1,
      homePresenter.selectedDate.day,
    );

    final title = isPreviousMonth
        ? "${DateFormat("dd/MM").format(previowsDate)} ${R.string.until.toLowerCase()} ${now.hour + 1}h"
        : "${R.string.until} ${now.hour + 1}h";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          totalValue.toString().toBrazilianNumber().addBrazilianCoin(),
          style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: color,
              ),
        ),
      ],
    );
  }
}
