import 'package:flutter/material.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';

class Periods extends StatelessWidget {
  final bool selectedDay;
  final void Function() onTapDaily;
  final void Function() onTapMonthly;
  const Periods({
    super.key,
    required this.selectedDay,
    required this.onTapDaily,
    required this.onTapMonthly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SelectPeriodItems(
        onTapDaily: onTapDaily,
        onTapMonthly: onTapMonthly,
        selectedPeriodType: PeriodType.daily,
      ),
    );
  }
}
