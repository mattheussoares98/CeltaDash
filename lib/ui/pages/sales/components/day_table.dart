import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

class DayTable extends StatelessWidget {
  final List<SaleStatisticViewModel> dailyStatistics;
  const DayTable({
    super.key,
    required this.dailyStatistics,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final salesPresenter = Get.find<SalesPresenter>();
    final totalInMounth = dailyStatistics.sumLiquidValue();
    final orientation = MediaQuery.of(context).orientation;

    return ScrollableTableItem(
      getSalesStatisticsParams: salesPresenter.lastGetDailyParams,
      titleMinHeight: orientation == Orientation.portrait ? 45 : 25,
      pdfFileName: R.string.dailyAnalysis,
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
        PersonalizedTableCell(value: R.string.day, isTitle: true),
        PersonalizedTableCell(value: R.string.sales, isTitle: true),
        PersonalizedTableCell(
            value: R.string.quantityAbbreviated, isTitle: true),
        PersonalizedTableCell(value: R.string.average, isTitle: true),
        PersonalizedTableCell(value: R.string.share, isTitle: true),
      ],
      rowValues:
          dailyStatistics.map((e) => e.Date?.day).toSet().toList().map((day) {
        final salesByDay = dailyStatistics
            .filteredSales(filterDay: day)
            .map((e) => e.toViewModel())
            .toList();

        final totalByDay = salesByDay.sumLiquidValue();
        final quantitySales = salesByDay.quantitySales();
        final rowDay = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          day ?? 0,
        );

        final subtitle = DateFormat('EEEE', 'pt_BR')
            .format(rowDay)
            .substring(0, 3)
            .toUpperCase();

        return [
          PersonalizedTableCell(
            value:
                "$day ${orientation == Orientation.landscape ? subtitle : ''}",
            subtile: orientation == Orientation.portrait ? subtitle : null,
          ),
          PersonalizedTableCell(value: totalByDay, isMoney: true),
          PersonalizedTableCell(value: quantitySales),
          PersonalizedTableCell(
            value: totalByDay / quantitySales,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: (totalByDay / totalInMounth) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
