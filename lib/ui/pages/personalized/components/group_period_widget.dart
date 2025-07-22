import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class GroupPeriodWidget extends StatefulWidget {
  const GroupPeriodWidget({super.key});

  @override
  State<GroupPeriodWidget> createState() => _GroupPeriodWidgetState();
}

class _GroupPeriodWidgetState extends State<GroupPeriodWidget> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.groupPeriod,
      children: PeriodGroupingType.values
          .map(
            (e) => CheckBoxItem(
              title: e.name,
              value: personalizedPresenter.periodGroupingTypes.contains(e),
              onTap: () {
                setState(() {
                  personalizedPresenter.changePeriodGroupingType(e);
                });
              },
            ),
          )
          .toList(),
    );
  }
}
