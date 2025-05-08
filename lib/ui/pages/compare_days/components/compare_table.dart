import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class CompareTable extends StatelessWidget {
  final DateTime firstDay;
  final DateTime secondDay;
  const CompareTable({
    super.key,
    required this.firstDay,
    required this.secondDay,
  });

  double calculateDifference(double day1, double day2) {
    if (day1 == 0 && day2 == 0) return 0.0;
    if (day1 == 0) return -100.0; // No sales on Day 1, some on Day 2
    return ((day1 - day2) / day1) * 100;
  }

  @override
  Widget build(BuildContext context) {
    CompareDaysPresenter compareDaysPresenter = Get.find();

    final hourWidth = MediaQuery.of(context).size.width * 0.2;
    final dayWidth = MediaQuery.of(context).size.width * 0.3;
    final compareDaysWidth = MediaQuery.of(context).size.width * 0.2;

    return TableItem(
      titles: [
        PersonalizedTableCell(value: R.string.hour),
        PersonalizedTableCell(value: DateFormat.yMd('pt_BR').format(firstDay)),
        PersonalizedTableCell(value: DateFormat.yMd('pt_BR').format(secondDay)),
        PersonalizedTableCell(value: R.string.differente),
      ],
      titleMinHeight: 40,
      indexToSort: 0,
      columnIndexToCompareAndDetachBetterAndWorstValue: 3,
      columnsIndexToSum: [1, 2],
      tableColumnWidth: {
        0: FixedColumnWidth(hourWidth),
        1: FixedColumnWidth(dayWidth),
        2: FixedColumnWidth(dayWidth),
        3: FixedColumnWidth(compareDaysWidth),
      },
      rowValues: compareDaysPresenter.saleMovements!
          .map((e) => e.Hour)
          .whereType<String>()
          .toSet()
          .toList()
          .map((hour) {
        final firstDay = compareDaysPresenter.selectedFirstDay?.day;
        final secondDay = compareDaysPresenter.selectedSecondDay?.day;

        final firstDayTotal = compareDaysPresenter.saleMovements!
            .where((e) => e.Hour == hour && e.Date!.day == firstDay)
            .map((e) => e.LiquidValue?.toDouble() ?? 0)
            .fold(0.0, (a, b) => a + b);

        final secondDayTotal = compareDaysPresenter.saleMovements!
            .where((e) => e.Hour == hour && e.Date!.day == secondDay)
            .map((e) => e.LiquidValue?.toDouble() ?? 0)
            .fold(0.0, (a, b) => a + b);

        final difference = calculateDifference(firstDayTotal, secondDayTotal);

        return [
          PersonalizedTableCell(value: hour),
          PersonalizedTableCell(value: firstDayTotal, isMoney: true),
          PersonalizedTableCell(value: secondDayTotal, isMoney: true),
          PersonalizedTableCell(value: difference, isPercentage: true),
        ];
      }).toList(),
    );
  }
}
