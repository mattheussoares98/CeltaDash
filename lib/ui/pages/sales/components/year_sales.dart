import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

class YearSales extends StatelessWidget {
  final List<SaleStatisticViewModel> saleStatisticsByYear;
  const YearSales({super.key, required this.saleStatisticsByYear});

  @override
  Widget build(BuildContext context) {
    final totalLiquidByYear = saleStatisticsByYear.sumLiquidValue();
    final salesPresenter = Get.find<SalesPresenter>();
    final orientation = MediaQuery.of(context).orientation;

    return ScrollableTableItem(
      getSalesStatisticsParams: null, //TODO add here
      titleMinHeight: orientation == Orientation.portrait ? 45 : 25,
      pdfFileName: R.string.yearlyAnalysis,
      showAnimation: _showAnimation,
      selectedPeriodType: salesPresenter.selectedPeriod,
      fixFirstColumn: true,
      hideShowAnimation: () {
        _showAnimation = false;
      },
      columnsWidths: [60, 110, 55, 60, 50],
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      indexToSort: 1,
      titles: [
        PersonalizedTableCell(value: R.string.year, isTitle: true),
        PersonalizedTableCell(value: R.string.sales, isTitle: true),
        PersonalizedTableCell(
            value: R.string.quantityAbbreviated, isTitle: true),
        PersonalizedTableCell(value: R.string.average, isTitle: true),
        PersonalizedTableCell(value: R.string.share, isTitle: true),
      ],
      rowValues:
          saleStatisticsByYear.map((e) => e.Year).toSet().toList().map((year) {
        final salesByCurrentYear = saleStatisticsByYear
            .filteredSales(filterYear: year?.toInt())
            .map((e) => e.toViewModel())
            .toList();

        final totalLiquidByCurrentYear = salesByCurrentYear.sumLiquidValue();
        final totalSalesByCurrentYear = salesByCurrentYear.quantitySales();

        return [
          PersonalizedTableCell(value: year),
          PersonalizedTableCell(
            value: totalLiquidByCurrentYear,
            isMoney: true,
          ),
          PersonalizedTableCell(value: totalSalesByCurrentYear),
          PersonalizedTableCell(
            value: totalLiquidByCurrentYear / totalSalesByCurrentYear,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: (totalLiquidByCurrentYear / totalLiquidByYear) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
