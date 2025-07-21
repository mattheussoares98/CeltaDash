import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class GroupPeriod extends StatelessWidget {
  const GroupPeriod({super.key});

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.groupPeriod,
      children: NonExclusiveGroupingType.values
          .map(
            (e) => CheckBoxItem(
              title: e.name,
              onTap: () {
                personalizedPresenter.changeNonExclusiveGroupingType(e);
              },
            ),
          )
          .toList(),
    );
  }
}
