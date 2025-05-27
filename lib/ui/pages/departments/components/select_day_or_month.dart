import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SelectDayOrMonth extends StatelessWidget {
  final void Function(bool) updateSelectedMonth;
  final int indexToSelectWhenRebuild;
  const SelectDayOrMonth({
    super.key,
    required this.updateSelectedMonth,
    required this.indexToSelectWhenRebuild,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SelectPeriodItems(
          indexToSelectWhenRebuild: indexToSelectWhenRebuild,
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
