import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class Periods extends StatelessWidget {
  final bool selectedDay;
  final void Function() selectDay;
  final void Function() selectMonth;
  const Periods({
    super.key,
    required this.selectedDay,
    required this.selectDay,
    required this.selectMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SelectPeriodItems(
        indexToSelectWhenRebuild: selectedDay ? 0 : 1,
        items: [
          SelectPeriodItems.createItem(
            title: R.string.day,
            onTap: selectDay,
          ),
          SelectPeriodItems.createItem(
            title: R.string.month,
            onTap: selectMonth,
          ),
        ],
      ),
    );
  }
}
