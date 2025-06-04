import 'package:flutter/widgets.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';

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
          selectedPeriodType: PeriodType.daily,
        ),
      ],
    );
  }
}
