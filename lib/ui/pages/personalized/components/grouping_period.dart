import 'package:flutter/material.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class GroupPeriod extends StatelessWidget {
  const GroupPeriod({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultExpansionTile(
      title: R.string.groupPeriod,
      children: [
        CheckBoxItem(
          title: PeriodType.hourly.name,
          onTap: () {
            //TODO implement
          },
        ),
        CheckBoxItem(
          title: PeriodType.daily.name,
          onTap: () {},
        ),
        CheckBoxItem(
          title: PeriodType.monthly.name,
          onTap: () {},
        ),
        CheckBoxItem(
          title: PeriodType.yearly.name,
          onTap: () {},
        ),
      ],
    );
  }
}
