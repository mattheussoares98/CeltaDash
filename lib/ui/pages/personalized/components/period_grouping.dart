import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class PeriodGrouping extends StatefulWidget {
  const PeriodGrouping({super.key});

  @override
  State<PeriodGrouping> createState() => _PeriodGroupingState();
}

class _PeriodGroupingState extends State<PeriodGrouping> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
//TODO change to radio
    return DefaultExpansionTile(
      title: R.string.groupPeriod,
      children: PeriodGroupingType.values
          .map((e) => CheckBoxItem(
                title: e.name,
                value: personalizedPresenter.periodGroupingType == e,
                onTap: () {
                  setState(() {
                    personalizedPresenter.changePeriodGroupingType(e);
                  });
                },
              ))
          .toList(),
    );
  }
}
