import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class HourTable extends StatelessWidget {
  const HourTable({super.key});

  @override
  Widget build(BuildContext context) {
    SalesPresenter salesPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    return TableItem(
      titleMinHeight: 43,
      tableColumnWidth: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
      },
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      titles: [
        PersonalizedTableCell(value: R.string.day.toUpperCase()),
        PersonalizedTableCell(
          value: R.string.totalSales.toUpperCase(),
        ),
        PersonalizedTableCell(value: R.string.share.toUpperCase()),
      ],
      rowValues: salesPresenter.saleMovements!.uniqueHours.toList().map((hour) {
        final t1 = salesPresenter.saleMovements!
            .totalForHourOnDate(hour, homePresenter.selectedDate);

        return [
          PersonalizedTableCell(
            value: hour,
          ),
          PersonalizedTableCell(value: t1, isMoney: true),
          PersonalizedTableCell(
            value:
                (t1 / salesPresenter.saleMovements!.uniqueHours.length) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
