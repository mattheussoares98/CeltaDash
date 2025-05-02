import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SelectDayOrMonth extends StatelessWidget {
  final void Function(bool) updateSelectedMonth;
  const SelectDayOrMonth({super.key, required this.updateSelectedMonth});

  @override
  Widget build(BuildContext context) {
    return SelectPeriodItems(
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
    );
  }
}
