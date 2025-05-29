import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class MonthSales extends StatelessWidget {
  final List<SaleMovementViewModel> saleMovementsByMonth;
  const MonthSales({super.key, required this.saleMovementsByMonth});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final totalLiquidByYear = saleMovementsByMonth.sumLiquidValue();
    final uniqueMonths =
        saleMovementsByMonth.map((e) => e.Date?.month).toSet().toList()..sort();

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
        PersonalizedTableCell(value: R.string.month.toUpperCase()),
        PersonalizedTableCell(value: R.string.revenue.toUpperCase()),
        PersonalizedTableCell(value: R.string.sales.toUpperCase()),
        PersonalizedTableCell(value: R.string.ticketAverage.toUpperCase()),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues: List.generate(uniqueMonths.length, (index) {
        final salesOfCurrentMonth = saleMovementsByMonth
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
