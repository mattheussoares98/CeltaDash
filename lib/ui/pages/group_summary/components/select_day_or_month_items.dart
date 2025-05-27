import 'package:flutter/widgets.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SelectDayOrMonthItems extends StatelessWidget {
  final void Function(bool selectDay) change;
  final int indexToSelectWhenRebuild;
  const SelectDayOrMonthItems({
    super.key,
    required this.change,
    required this.indexToSelectWhenRebuild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectPeriodItems(
          indexToSelectWhenRebuild: indexToSelectWhenRebuild,
          items: [
            SelectPeriodItems.createItem(
              title: R.string.day,
              onTap: () {
                change(true);
              },
            ),
            SelectPeriodItems.createItem(
              title: R.string.month,
              onTap: () {
                change(false);
              },
            ),
          ],
        ),
      ],
    );
  }
}
