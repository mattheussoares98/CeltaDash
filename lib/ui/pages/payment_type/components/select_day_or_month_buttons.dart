import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SelectDayOrMonthButtons extends StatelessWidget {
  final bool selectedMonth;
  final void Function(bool) updateSelectedMonth;
  const SelectDayOrMonthButtons({
    super.key,
    required this.selectedMonth,
    required this.updateSelectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectPeriodItems(
          indexToSelectWhenRebuild: selectedMonth ? 1 : 0,
          items: [
            SelectPeriodItems.createItem(
              title: R.string.day,
              onTap: () {
                updateSelectedMonth(false);
              },
            ),
            SelectPeriodItems.createItem(
              title: R.string.month,
              onTap: () {
                updateSelectedMonth(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
