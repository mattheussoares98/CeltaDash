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
        selectedDayLiquidValue == 0.0 || previousMonthLiquidValue == 0.0
            ? 0.0
            : (selectedDayLiquidValue / previousMonthLiquidValue * 100 - 100);

    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          if (resumePresenter.compareDaysStatistics == null ||
              resumePresenter.compareDaysStatistics!.isEmpty)
            EmptySales(isLoading: false),
          if (resumePresenter.compareDaysStatistics != null &&
              resumePresenter.compareDaysStatistics!.isNotEmpty)
            Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: R.string.salesOfTheDay.toUpperCase()),
                      TextSpan(
                        text:
                            " (${percentageResult.toString().toBrazilianNumber(0)}%)",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: percentageResult >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                      ),
                    ],
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                ChartPieWidget(
                  paddingItems: EdgeInsets.all(1),
                  showTotalAmount: false,
                  centerDate: resumePresenter.lastGetComparisonParams?.endDate,
                  centerPassedColor: Colors.grey[400]!,
                  centerRemainingColor: Colors.white,
                  pieParameters: [
                    PieParameter(
                      title: Title(
                        isCurrentDay: isCurrentDay,
                        now: now,
                        isPreviousMonth: false,
                        statistics: selectedDayStatistics ?? [],
                        color:
                            percentageResult >= 0 ? Colors.green : Colors.red,
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
              ],
            ),
          Row(
            children: [
              Expanded(
                child: DefaultButton(
                  onTap: homePresenter.goToPaymentsTypePage,
                  title: R.string.payments,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultButton(
                  onTap: homePresenter.goToDepartmentsPage,
                  title: R.string.departments,
                ),
              ),
            ],
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
      style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
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

    final title =
        isPreviousMonth ? DateFormat("dd/MM").format(previowsDate) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title,
            style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        FittedBox(
          child: Text(
            totalValue.toString().toBrazilianNumber().addBrazilianCoin(),
            style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: color,
                ),
          ),
        ),
      ],
    );
  }
}
