import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class YearSales extends StatelessWidget {
  final List<SaleMovementViewModel> saleMovementsByYear;
  const YearSales({super.key, required this.saleMovementsByYear});

  @override
  Widget build(BuildContext context) {
    final totalLiquidByYear = saleMovementsByYear.sumLiquidValue();

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
      titles: [
        PersonalizedTableCell(value: R.string.year.toUpperCase()),
        PersonalizedTableCell(value: R.string.revenue.toUpperCase()),
        PersonalizedTableCell(value: R.string.sales.toUpperCase()),
        PersonalizedTableCell(value: R.string.ticketAverage.toUpperCase()),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues:
          saleMovementsByYear.map((e) => e.Year).toSet().toList().map((year) {
        final salesByCurrentYear = saleMovementsByYear
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
