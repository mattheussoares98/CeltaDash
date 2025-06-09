import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class Result extends StatelessWidget {
  final DateTime firstDay;
  final DateTime secondDay;
  const Result({
    super.key,
    required this.firstDay,
    required this.secondDay,
  });

  @override
  Widget build(BuildContext context) {
    CompareDaysPresenter compareDaysPresenter = Get.find();

    return Builder(builder: (context) {
      final firstDayTotalLiquid =
          compareDaysPresenter.saleStatistics!.sumLiquidValue(
        filterDay: firstDay.day,
        filterMonth: firstDay.month,
        filterYear: firstDay.year,
      );
      final secondDayTotalLiquid =
          compareDaysPresenter.saleStatistics!.sumLiquidValue(
        filterDay: secondDay.day,
        filterMonth: secondDay.month,
        filterYear: secondDay.year,
      );

      if (compareDaysPresenter.selectedFirstDay == null ||
          compareDaysPresenter.selectedSecondDay == null) {
        return SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                "${R.string.day} ${DateFormat.yMd("pt_BR").format(firstDay)} ",
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
            children: [
              TextSpan(text: R.string.sold.toLowerCase()),
              TextSpan(
                text:
                    " ${compareDaysPresenter.saleStatistics!.differenceForHour(firstDayTotalLiquid, secondDayTotalLiquid).toString().toBrazilianNumber()}% ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: firstDayTotalLiquid > secondDayTotalLiquid
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              TextSpan(text: R.string.comparedToDay.toLowerCase()),
              TextSpan(text: " ${DateFormat.yMd("pt_BR").format(secondDay)}"),
            ],
          ),
        ),
      );
    });
  }
}
