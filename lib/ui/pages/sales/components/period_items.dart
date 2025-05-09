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

  const PeriodItems({super.key, required this.updateSelectedItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectPeriodItems(
            items: [
              SelectPeriodItems.createItem(
                title: R.string.hour,
                onTap: () {
                  updateSelectedItem(filterByHour: true);
                },
              ),
              SelectPeriodItems.createItem(
                title: R.string.day,
                onTap: () {
                  updateSelectedItem(filterByDay: true);
                },
              ),
              SelectPeriodItems.createItem(
                title: R.string.month,
                onTap: () {
                  updateSelectedItem(filterByMonth: true);
                },
              ),
              SelectPeriodItems.createItem(
                title: R.string.year,
                onTap: () {
                  updateSelectedItem(filterByYear: true);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
