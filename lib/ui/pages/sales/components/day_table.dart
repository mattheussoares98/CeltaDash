import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class DayTable extends StatelessWidget {
  final List<SaleMovementViewModel> resumeSaleMovements;
  const DayTable({
    super.key,
    required this.resumeSaleMovements,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final totalInMounth = resumeSaleMovements.sumLiquidValue();

    return TableItem(
      titleMinHeight: 43,
      tableColumnWidth: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
      },
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1],
      indexToSort: 0,
      titles: [
        PersonalizedTableCell(value: R.string.day.toUpperCase()),
        PersonalizedTableCell(
          value: R.string.totalSales.toUpperCase(),
        ),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues:
          resumeSaleMovements.map((e) => e.Date?.day).toSet().toList().map((day) {
        final salesByDay = resumeSaleMovements
            .filteredSales(filterDay: day)
            .map((e) => e.toViewModel())
            .toList();

        final totalByDay = salesByDay.sumLiquidValue();
        final rowDay = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          day ?? 0,
        );

        return [
          PersonalizedTableCell(
            value: day?.toString(),
            subtile: DateFormat('EEEE', 'pt_BR')
                .format(rowDay)
                .substring(0, 3)
                .toUpperCase(),
          ),
          PersonalizedTableCell(
              value: salesByDay.sumLiquidValue(), isMoney: true),
          PersonalizedTableCell(
            value: (totalByDay / totalInMounth) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
