import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class HourTable extends StatelessWidget {
  final List<SaleStatisticViewModel> hourlyStatistics;
  const HourTable({
    super.key,
    required this.hourlyStatistics,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final totalValue = hourlyStatistics.sumLiquidValue(
      enterprise: homePresenter.selectedEnterprise,
      filterDay: homePresenter.selectedDate.day,
      filterMonth: homePresenter.selectedDate.month,
      filterYear: homePresenter.selectedDate.year,
    );

    final uniqueHours = hourlyStatistics.uniqueHours();

    return TableItem(
      titleMinHeight: 43,
      tableColumnWidth: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15),
        2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.19),
        3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
        4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
      },
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      indexToSort: 0,
      titles: [
        PersonalizedTableCell(value: R.string.hour.toUpperCase()),
        PersonalizedTableCell(value: R.string.sales.toUpperCase()),
        PersonalizedTableCell(value: R.string.sales.toUpperCase()),
        PersonalizedTableCell(value: R.string.average.toUpperCase()),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues: uniqueHours.map((hour) {
        final totalByHour = hourlyStatistics.totalForHourOnDate(
            hour, homePresenter.selectedDate);

        final salesByHour = hourlyStatistics
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
