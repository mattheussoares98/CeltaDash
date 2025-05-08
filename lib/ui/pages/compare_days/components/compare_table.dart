import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class CompareTable extends StatelessWidget {
  final double Function(double day1, double day2) calculateDifferencePercentage;
  final DateTime firstDay;
  final DateTime secondDay;
  const CompareTable({
    super.key,
    required this.calculateDifferencePercentage,
    required this.firstDay,
    required this.secondDay,
  });

  @override
  Widget build(BuildContext context) {
    CompareDaysPresenter compareDaysPresenter = Get.find();

    final hourWidth = MediaQuery.of(context).size.width * 0.2;
    final dayWidth = MediaQuery.of(context).size.width * 0.3;
    final compareDaysWidth = MediaQuery.of(context).size.width * 0.2;

    if (compareDaysPresenter.selectedFirstDay == null ||
        compareDaysPresenter.selectedSecondDay == null) {
      return SizedBox.shrink();
    }

    return TableItem(
      titles: [
        PersonalizedTableCell(value: R.string.hour),
        PersonalizedTableCell(
          value: DateFormat.yMd('pt_BR')
              .format(compareDaysPresenter.selectedFirstDay!),
        ),
        PersonalizedTableCell(
          value: DateFormat.yMd('pt_BR')
              .format(compareDaysPresenter.selectedSecondDay!),
        ),
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
        final firstDayTotal = compareDaysPresenter.saleMovements!
            .where((e) =>
                e.Hour == hour &&
                e.Date!.day == firstDay.day &&
                e.Date!.month == firstDay.month &&
                e.Date!.year == firstDay.year)
            .map((e) => e.LiquidValue?.toDouble() ?? 0)
            .fold(0.0, (a, b) => a + b);

        final secondDayTotal = compareDaysPresenter.saleMovements!
            .where((e) =>
                e.Hour == hour &&
                e.Date!.day == secondDay.day &&
                e.Date!.month == secondDay.month &&
                e.Date!.year == secondDay.year)
            .map((e) => e.LiquidValue?.toDouble() ?? 0)
            .fold(0.0, (a, b) => a + b);

        final difference =
            calculateDifferencePercentage(firstDayTotal, secondDayTotal);

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
