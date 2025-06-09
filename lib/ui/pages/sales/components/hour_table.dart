import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class HourTable extends StatelessWidget {
  final List<SaleStatisticViewModel> resumeSaleStatistics;
  final List<String> uniqueHours;
  const HourTable({
    super.key,
    required this.resumeSaleStatistics,
    required this.uniqueHours,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final totalValue = resumeSaleStatistics.sumLiquidValue(
      enterprise: homePresenter.selectedEnterprise,
      filterDay: homePresenter.selectedDate.day,
      filterMonth: homePresenter.selectedDate.month,
      filterYear: homePresenter.selectedDate.year,
    );

    return TableItem(
      titleMinHeight: 43,
      tableColumnWidth: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
        2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.19),
        3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
        4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
      },
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      indexToSort: 0,
      titles: [
        PersonalizedTableCell(value: R.string.hour.toUpperCase()),
        PersonalizedTableCell(value: R.string.revenue.toUpperCase()),
        PersonalizedTableCell(value: R.string.sales.toUpperCase()),
        PersonalizedTableCell(value: R.string.ticketAverage.toUpperCase()),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues: uniqueHours.map((hour) {
        final totalByHour = resumeSaleStatistics.totalForHourOnDate(
            hour, homePresenter.selectedDate);

        final salesByHour = resumeSaleStatistics
            .filteredSales(
              enterprise: homePresenter.selectedEnterprise,
              filterDay: homePresenter.selectedDate.day,
              filterMonth: homePresenter.selectedDate.month,
              filterYear: homePresenter.selectedDate.year,
            )
            .map((e) => e.toViewModel())
            .where((e) => e.Hour == hour)
            .toList()
            .quantitySales();

        return [
          PersonalizedTableCell(value: hour),
          PersonalizedTableCell(value: totalByHour, isMoney: true),
          PersonalizedTableCell(value: salesByHour),
          PersonalizedTableCell(
            value: totalByHour / salesByHour,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: (totalByHour / totalValue) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
