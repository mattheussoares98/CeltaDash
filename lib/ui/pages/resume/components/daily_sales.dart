import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';
import 'components.dart';

class DailyStatistics extends StatelessWidget {
  final ScrollController scrollController;
  final List<SaleStatisticViewModel> saleStatistics;
  const DailyStatistics({
    super.key,
    required this.scrollController,
    required this.saleStatistics,
  });

  String getSubTitle(
    List<SaleStatisticViewModel> statistics,
    HomePresenter homePresenter,
  ) {
    String subtitle = "";

    if (statistics.isEmpty) {
      return subtitle;
    }
    double totalTickets = statistics
        .quantitySales(enterprise: homePresenter.selectedEnterprise)
        .toDouble();

    double totalValue = statistics.sumLiquidValue();
    subtitle +=
        "${R.string.sales}: ${totalValue.toString().toBrazilianNumber().addBrazilianCoin()}";
    subtitle +=
        "\n${R.string.quantityAbbreviated}: ${totalTickets.toString().toBrazilianNumber()}";
    subtitle +=
        "\n${R.string.average}: ${statistics.ticketAverage(homePresenter.selectedEnterprise).toString().toBrazilianNumber().addBrazilianCoin()}";

    return subtitle;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();

    if (kDebugMode) {
      //TODO remove this
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

      return Container(
        decoration: ContainerDecoration.decoration,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ChartPie(
          showTotalAmount: false,
          centerSpaceRadius: 50,
          centerDate: homePresenter.selectedDate,
          centerPassedColor: Colors.grey[350]!,
          centerRemainingColor: Colors.white,
          pieParameters: [
            PieParameter(
              title: "${DateFormat("dd/MM").format(
                homePresenter.selectedDate,
              )}"
                  "${isCurrentDay ? " ${R.string.until.toLowerCase()} ${now.hour + 1}h" : ""}",
              color: Colors.green,
              subtitle: getSubTitle(
                selectedDayStatistics ?? [],
                homePresenter,
              ),
              value: selectedDayStatistics?.sumLiquidValue() ?? 1,
            ),
            PieParameter(
              title: "${DateFormat("dd/MM").format(DateTime(
                homePresenter.selectedDate.year,
                homePresenter.selectedDate.month - 1,
                homePresenter.selectedDate.day,
              ))}"
                  "${isCurrentDay ? " ${R.string.until.toLowerCase()} ${now.hour + 1}h" : ""}",
              color: Colors.orange,
              subtitle: getSubTitle(
                previousMonthStatistics ?? [],
                homePresenter,
              ),
              showSubtitleOnlyOnTap: true,
              value: previousMonthStatistics?.sumLiquidValue() ?? 1,
            ),
          ],
        ),
      );
    }

    return SalesInformations(
      scrollController: scrollController,
      title: R.string.salesOfTheDay,
      totalSales: saleStatistics.sumLiquidValue(
        enterprise: homePresenter.selectedEnterprise,
        filterYear: homePresenter.selectedDate.year,
        filterMonth: homePresenter.selectedDate.month,
        filterDay: homePresenter.selectedDate.day,
      ),
      bottomChildren: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DefaultButton(
                  onTap: resumePresenter.goToPaymentsTypePage,
                  title: R.string.payments,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultButton(
                  onTap: resumePresenter.goToDepartmentsPage,
                  title: R.string.departments,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultButton(
              onTap: resumePresenter.goToCompareDays,
              title: R.string.compareDays,
            ),
          ],
        ),
      ],
      leftButton: null,
      rightButton: null,
      rightChildren: [
        Text(
          R.string.salesQuantity,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          saleStatistics
              .quantitySales(
                enterprise: homePresenter.selectedEnterprise,
                filterYear: homePresenter.selectedDate.year,
                filterMonth: homePresenter.selectedDate.month,
                filterDay: homePresenter.selectedDate.day,
              )
              .toString()
              .toBrazilianNumber(0),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
        Text(
          R.string.ticketAverage,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          (saleStatistics.ticketAverage(
            homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year,
            filterMonth: homePresenter.selectedDate.month,
            filterDay: homePresenter.selectedDate.day,
          )).toString().toBrazilianNumber().addBrazilianCoin(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}
