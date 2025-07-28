import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

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

    if (compareDaysPresenter.selectedFirstDay == null ||
        compareDaysPresenter.selectedSecondDay == null) {
      return const SizedBox.shrink();
    }

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return ScrollableTableItem(
      getSalesStatisticsParams: null, //TODO add here
      titleMinHeight: isPortrait ? 40 : 25,
      fixFirstColumn: true,
      pdfFileName: R.string.compareDays,
      indexToSort: 0,
      columnIndexToCompareAndDetachBetterAndWorstValue: 3,
      columnsIndexToSum: [1, 2],
      columnsWidths: [80, 75, 75, 70],
      showAnimation: _showAnimation,
      hideShowAnimation: () {
        _showAnimation = false;
      },
      titles: [
        PersonalizedTableCell(
          value: R.string.hour,
          isTitle: true,
        ),
        PersonalizedTableCell(
          value: DateFormat.yMd('pt_BR').format(
            compareDaysPresenter.selectedFirstDay!,
          ),
          isTitle: true,
        ),
        PersonalizedTableCell(
          value: DateFormat.yMd('pt_BR')
              .format(compareDaysPresenter.selectedSecondDay!),
          isTitle: true,
        ),
        PersonalizedTableCell(
          value: R.string.difference,
          isTitle: true,
        ),
      ],
      rowValues: compareDaysPresenter.saleStatistics!
          .uniqueHours()
          .toList()
          .map((hour) {
        final t1 = compareDaysPresenter.saleStatistics!
            .totalForHourOnDate(hour, firstDay);
        final t2 = compareDaysPresenter.saleStatistics!
            .totalForHourOnDate(hour, secondDay);
        final diff =
            compareDaysPresenter.saleStatistics!.differenceForHour(t1, t2);
        if (!isPortrait) {
          hour = hour.replaceAll(RegExp(r'\n'), ' ~ ');
        }

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
