import 'package:celta_dash/ui/components/chart_prices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/models.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class MonthlyAnalysis extends StatelessWidget {
  final List<SaleMovementViewModel> saleMovements;
  const MonthlyAnalysis({super.key, required this.saleMovements});

  bool isToday(DateTime? date) {
    final now = DateTime.now();

    return date?.day == now.day &&
        date?.month == now.month &&
        date?.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    final datesAndValues = (saleMovements
            .where((e) =>
                e.EnterpriseId == homePresenter.selectedEnterprise?.id &&
                e.Date?.month == homePresenter.selectedDate.month &&
                !isToday(e.Date))
            .map((e) => e.Date!.day)
            .toSet()
            .toList()
          ..sort())
        .map((day) {
      final salesByDay = saleMovements
          .where((e) =>
              e.EnterpriseId == homePresenter.selectedEnterprise?.id &&
              e.Date?.day == day &&
              e.Date?.month == homePresenter.selectedDate.month)
          .toList();

      final firstSale = salesByDay.first;

      return DateAndValueModel(
        value: salesByDay.sumLiquidValue(),
        date: DateTime(
          firstSale.Date!.year,
          firstSale.Date!.month,
          firstSale.Date!.day,
        ),
      );
    }).toList();

    DateAndValueModel? betterValue = datesAndValues.isEmpty
        ? null
        : datesAndValues.reduce(
            (a, b) => a.value > b.value ? a : b,
          );
    DateAndValueModel? worstValue = datesAndValues.isEmpty
        ? null
        : datesAndValues.reduce(
            (a, b) => a.value < b.value ? a : b,
          );

    final averageValue = datesAndValues.fold(
          0.0,
          (previous, element) => previous + element.value,
        ) /
        datesAndValues.length;

    if (betterValue == null || worstValue == null) return SizedBox();

    return Container(
      decoration: ContainerDecoration.decoration,
      padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Column(
        children: [
          Text(
            R.string.monthlyAnalysis,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      R.string.totalSales,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      saleMovements
                          .sumLiquidValue(
                            enterprise: homePresenter.selectedEnterprise,
                          )
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      R.string.averageDailySale,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      averageValue
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CompareTimesResult(
            betterTime: DateFormat("dd/MM").format(betterValue.date),
            worstTime: DateFormat("dd/MM").format(worstValue.date),
            betterValue: betterValue.value,
            worstValue: worstValue.value,
            betterTimeMessage: R.string.bestDayOfTheMonth,
            worstTimeMessage: R.string.worstDayOfTheMonth,
          ),
          const SizedBox(height: 8),
          ChartPrices(datesAndValues: datesAndValues),
        ],
      ),
    );
  }
}
