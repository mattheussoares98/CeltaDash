import 'package:flutter/widgets.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';

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
              selectedPeriodType: PeriodType.daily,
            ),
          ),
        ),
      ],
    );
  }
}
