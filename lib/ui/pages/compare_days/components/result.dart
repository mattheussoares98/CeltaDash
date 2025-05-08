import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class Result extends StatelessWidget {
  const Result({
    super.key,
  });

  double getTotalDifference({required double first, required double second}) {
    if (first > second) {
      return (first / second - 1) * 100;
    } else {
      return -((second - first) / first) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    CompareDaysPresenter compareDaysPresenter = Get.find();

    return Builder(builder: (context) {
      final firstDayTotalLiquid =
          compareDaysPresenter.saleMovements!.sumLiquidValue(
        filterDay: compareDaysPresenter.selectedFirstDay?.day,
      );
      final secondDayTotalLiquid =
          compareDaysPresenter.saleMovements!.sumLiquidValue(
        filterDay: compareDaysPresenter.selectedSecondDay?.day,
      );

      if (compareDaysPresenter.selectedFirstDay == null ||
          compareDaysPresenter.selectedSecondDay == null) {
        return SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: DayComparison(
          firstDate: compareDaysPresenter.selectedFirstDay!,
          secondDate: compareDaysPresenter.selectedSecondDay!,
          totalDifference: getTotalDifference(
            first: firstDayTotalLiquid,
            second: secondDayTotalLiquid,
          ),
          totalFirstDay: firstDayTotalLiquid,
          totalSecondDay: secondDayTotalLiquid,
        ),
      );
    });
  }
}
