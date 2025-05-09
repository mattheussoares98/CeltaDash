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

    return TableItem(
      titleMinHeight: 43,
      tableColumnWidth: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
        2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.20),
        3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.20),
      },
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      titles: [
        PersonalizedTableCell(value: R.string.month.toUpperCase()),
        PersonalizedTableCell(
          value: R.string.totalSales.toUpperCase(),
        ),
        PersonalizedTableCell(
          value: R.string.salesQuantityAbbreviated.toUpperCase(),
        ),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues: List.generate(DateTime.now().month, (index) {
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

        return [
          PersonalizedTableCell(value: monthAbbreviation),
          PersonalizedTableCell(
            value: totalLiquidByMonth,
            isMoney: true,
          ),
          PersonalizedTableCell(value: salesOfCurrentMonth.quantitySales()),
          PersonalizedTableCell(
            value: (totalLiquidByMonth / totalLiquidByYear) * 100,
            isPercentage: true,
          ),
        ];
      }).reversed.toList(),
    );
  }
}
