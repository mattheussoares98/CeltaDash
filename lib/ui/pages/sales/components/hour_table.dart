import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

class HourTable extends StatelessWidget {
  final List<SaleStatisticViewModel> hourlyStatistics;
  const HourTable({
    super.key,
    required this.hourlyStatistics,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final salesPresenter = Get.find<SalesPresenter>();
    final totalValue = hourlyStatistics.sumLiquidValue(
      enterprise: homePresenter.selectedEnterprise,
      filterDay: homePresenter.selectedDate.day,
      filterMonth: homePresenter.selectedDate.month,
      filterYear: homePresenter.selectedDate.year,
    );
    final uniqueHours = hourlyStatistics.uniqueHours();
    final orientation = MediaQuery.of(context).orientation;

    return ScrollableTableItem(
      titleMinHeight: orientation == Orientation.portrait ? 45 : 25,
      pdfFileName: R.string.hourlyAnalysis,
      showAnimation: _showAnimation,
      selectedPeriodType: salesPresenter.selectedPeriod,
      fixFirstColumn: true,
      hideShowAnimation: () {
        _showAnimation = false;
      },
      columnsWidths: [60, 90, 40, 60, 50],
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      indexToSort: 0,
      titles: [
        PersonalizedTableCell(value: R.string.hour, isTitle: true),
        PersonalizedTableCell(value: R.string.sales, isTitle: true),
        PersonalizedTableCell(
            value: R.string.quantityAbbreviated, isTitle: true),
        PersonalizedTableCell(value: R.string.average, isTitle: true),
        PersonalizedTableCell(value: R.string.share, isTitle: true),
      ],
      rowValues: uniqueHours.map((hour) {
        final totalByHour = hourlyStatistics.totalForHourOnDate(
          hour,
          homePresenter.selectedDate,
        );

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

        if (orientation == Orientation.landscape) {
          hour = hour.replaceAll(RegExp(r'\n'), ' ~ ');
        }

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
