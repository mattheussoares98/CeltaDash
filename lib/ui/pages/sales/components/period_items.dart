import 'package:flutter/widgets.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class PeriodItems extends StatelessWidget {
  final void Function({
    bool? filterByHour,
    bool? filterByDay,
    bool? filterByMonth,
    bool? filterByYear,
  }) updateSelectedItem;
  final int indexToSelectWhenRebuild;

  const PeriodItems({
    super.key,
    required this.updateSelectedItem,
    required this.indexToSelectWhenRebuild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectPeriodItems(
              indexToSelectWhenRebuild: indexToSelectWhenRebuild,
              items: [
                SelectPeriodItems.createItem(
                  title: R.string.hours,
                  onTap: () {
                    updateSelectedItem(filterByHour: true);
                  },
                ),
                SelectPeriodItems.createItem(
                  title: R.string.days,
                  onTap: () {
                    updateSelectedItem(filterByDay: true);
                  },
                ),
                SelectPeriodItems.createItem(
                  title: R.string.months,
                  onTap: () {
                    updateSelectedItem(filterByMonth: true);
                  },
                ),
                SelectPeriodItems.createItem(
                  title: R.string.years,
                  onTap: () {
                    updateSelectedItem(filterByYear: true);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
