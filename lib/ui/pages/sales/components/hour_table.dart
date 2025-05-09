import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class HourTable extends StatelessWidget {
  final List<SaleMovementViewModel> resumeSaleMovements;
  final List<String> uniqueHours;
  const HourTable({
    super.key,
    required this.resumeSaleMovements,
    required this.uniqueHours,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final totalValue = resumeSaleMovements.sumLiquidValue(
      enterprise: homePresenter.selectedEnterprise,
      filterDay: homePresenter.selectedDate.day,
      filterMonth: homePresenter.selectedDate.month,
      filterYear: homePresenter.selectedDate.year,
    );

    return TableItem(
      titleMinHeight: 43,
      tableColumnWidth: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
        2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.20),
        3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.20),
      },
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1],
      indexToSort: 0,
      titles: [
        PersonalizedTableCell(value: R.string.hour.toUpperCase()),
        PersonalizedTableCell(
          value: R.string.totalSales.toUpperCase(),
        ),
        PersonalizedTableCell(
          value: R.string.salesQuantityAbbreviated.toUpperCase(),
        ),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues: uniqueHours.map((hour) {
        final totalByHour = resumeSaleMovements.totalForHourOnDate(
            hour, homePresenter.selectedDate);

        final salesByHour = resumeSaleMovements
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
            value: (totalByHour / totalValue) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
