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
          .uniqueHours()
          .toList()
          .map((hour) {
        final t1 = compareDaysPresenter.saleMovements!
            .totalForHourOnDate(hour, firstDay);
        final t2 = compareDaysPresenter.saleMovements!
            .totalForHourOnDate(hour, secondDay);
        final diff =
            compareDaysPresenter.saleMovements!.differenceForHour(t1, t2);

        return [
          PersonalizedTableCell(value: hour),
          PersonalizedTableCell(value: t1, isMoney: true),
          PersonalizedTableCell(value: t2, isMoney: true),
          PersonalizedTableCell(value: diff, isPercentage: true),
        ];
      }).toList(),
    );
  }
}
