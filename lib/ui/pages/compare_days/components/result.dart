import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class Result extends StatelessWidget {
  final DateTime firstDay;
  final DateTime secondDay;
  const Result({
    super.key,
    required this.firstDay,
    required this.secondDay,
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
    CompareDaysPresenter compareDaysPresenter =
        Provider.of(context, listen: false);

    return Builder(builder: (context) {
      final firstDayTotalLiquid =
          compareDaysPresenter.saleMovements!.sumLiquidValue(
        filterDay: compareDaysPresenter.selectedFirstDay?.day,
      );
      final secondDayTotalLiquid =
          compareDaysPresenter.saleMovements!.sumLiquidValue(
        filterDay: compareDaysPresenter.selectedSecondDay?.day,
      );

      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TotalSalesByDay(
                    date: compareDaysPresenter.selectedFirstDay ?? firstDay,
                    totalSales: firstDayTotalLiquid,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TotalSalesByDay(
                    date: compareDaysPresenter.selectedSecondDay ?? secondDay,
                    totalSales: secondDayTotalLiquid,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DayComparison(
              firstDate: compareDaysPresenter.selectedFirstDay ?? firstDay,
              secondDate: compareDaysPresenter.selectedSecondDay ?? secondDay,
              totalDifference: getTotalDifference(
                first: firstDayTotalLiquid,
                second: secondDayTotalLiquid,
              ),
              totalFirstDay: firstDayTotalLiquid,
              totalSecondDay: secondDayTotalLiquid,
            ),
          ],
        ),
      );
    });
  }
}
