import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class MonthSales extends StatelessWidget {
  final List<SaleStatisticViewModel> saleStatisticsByMonth;
  const MonthSales({super.key, required this.saleStatisticsByMonth});

  @override
  Widget build(BuildContext context) {
    final salesPresenter = Get.find<SalesPresenter>();
    final totalLiquidByYear = saleStatisticsByMonth.sumLiquidValue();
    final orientation = MediaQuery.of(context).orientation;

    saleStatisticsByMonth.sort((a, b) => a.Month!.compareTo(b.Month!));

    return ScrollableTableItem(
      getSalesStatisticsParams: salesPresenter.lastGetMonthlyParams,
      titleMinHeight: orientation == Orientation.portrait ? 45 : 25,
      pdfFileName: R.string.monthlyAnalysis,
      selectedPeriodType: salesPresenter.selectedPeriod,
      fixFirstColumn: true,
      columnsWidths: const [60, 110, 55, 60, 50],
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: const [1, 2],
      titles: [
        PersonalizedTableCell(value: R.string.month, isTitle: true),
        PersonalizedTableCell(value: R.string.sales, isTitle: true),
        PersonalizedTableCell(
          value: R.string.quantityAbbreviated,
          isTitle: true,
        ),
        PersonalizedTableCell(value: R.string.average, isTitle: true),
        PersonalizedTableCell(value: R.string.share, isTitle: true),
      ],
      rowValues: saleStatisticsByMonth
          .map((e) {
            final monthAbbreviation = DateFormat.MMM("pt_BR")
                .format(DateTime(e.Year!.toInt()!, e.Month!.toInt()!))
                .toString()
                .toUpperCase()
                .substring(0, 3);

            final totalLiquidByMonth = e.LiquidValue?.toDouble() ?? 0;
            final totalQuantityByMonth = e.QuantitySales?.toDouble() ?? 0;

            return [
              PersonalizedTableCell(value: monthAbbreviation),
              PersonalizedTableCell(value: totalLiquidByMonth, isMoney: true),
              PersonalizedTableCell(value: totalQuantityByMonth),
              PersonalizedTableCell(
                value:
                    totalLiquidByMonth /
                    (totalQuantityByMonth == 0 ? 1 : totalQuantityByMonth),
                isMoney: true,
              ),
              PersonalizedTableCell(
                value: (totalLiquidByMonth / totalLiquidByYear) * 100,
                isPercentage: true,
              ),
            ];
          })
          .toList()
          .reversed
          .toList(),
    );
  }
}
