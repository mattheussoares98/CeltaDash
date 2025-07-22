import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class GroupPeriod extends StatefulWidget {
  const GroupPeriod({super.key});

  @override
  State<GroupPeriod> createState() => _GroupPeriodState();
}

class _GroupPeriodState extends State<GroupPeriod> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.groupPeriod,
      children: NonExclusiveGroupingType.values
          .map(
            (e) => CheckBoxItem(
              title: e.name,
              value:
                  personalizedPresenter.nonExclusiveGroupingTypes.contains(e),
              onTap: () {
                setState(() {
                  personalizedPresenter.changeNonExclusiveGroupingType(e);
                });
              },
            ),
          )
          .toList(),
    );
  }
}
