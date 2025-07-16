import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

class MonthSales extends StatelessWidget {
  final List<SaleStatisticViewModel> saleStatisticsByMonth;
  const MonthSales({super.key, required this.saleStatisticsByMonth});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final salesPresenter = Get.find<SalesPresenter>();
    final totalLiquidByYear = saleStatisticsByMonth.sumLiquidValue();
    final uniqueMonths =
        saleStatisticsByMonth.map((e) => e.Month).toSet().toList()..sort();

    return ScrollableTableItem(
      titleMinHeight: 45,
      pdfFileName: R.string.monthlyAnalysis,
      showAnimation: _showAnimation,
      selectedPeriodType: salesPresenter.selectedPeriod,
      fixFirstColumn: true,
      hideShowAnimation: () {
        _showAnimation = false;
      },
      columnsWidths: [60, 110, 55, 60, 50],
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      titles: [
        PersonalizedTableCell(value: R.string.month, isTitle: true),
        PersonalizedTableCell(value: R.string.sales, isTitle: true),
        PersonalizedTableCell(
            value: R.string.quantityAbbreviated, isTitle: true),
        PersonalizedTableCell(value: R.string.average, isTitle: true),
        PersonalizedTableCell(value: R.string.share, isTitle: true),
      ],
      rowValues: List.generate(uniqueMonths.length, (index) {
        final salesOfCurrentMonth = saleStatisticsByMonth
            .filteredSales(
              enterprise: homePresenter.selectedEnterprise,
              filterMonth: index + 1,
            )
            .map((e) => e.toViewModel())
            .toList();

        final monthAbbreviation = DateFormat.MMM("pt_BR")
            .format(DateTime(homePresenter.selectedDate.year, index + 1))
            .toString()
            .toUpperCase()
            .substring(0, 3);

        final totalLiquidByMonth = salesOfCurrentMonth.sumLiquidValue();
        final totalQuantityByMonth = salesOfCurrentMonth.quantitySales();

        return [
          PersonalizedTableCell(value: monthAbbreviation),
          PersonalizedTableCell(
            value: totalLiquidByMonth,
            isMoney: true,
          ),
          PersonalizedTableCell(value: totalQuantityByMonth),
          PersonalizedTableCell(
            value: totalLiquidByMonth / totalQuantityByMonth,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: (totalLiquidByMonth / totalLiquidByYear) * 100,
            isPercentage: true,
          ),
        ];
      }).reversed.toList(),
    );
  }
}
