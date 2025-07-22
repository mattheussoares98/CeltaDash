import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class ExclusiveGrouping extends StatefulWidget {
  const ExclusiveGrouping({super.key});

  @override
  State<ExclusiveGrouping> createState() => _ExclusiveGroupingState();
}

class _ExclusiveGroupingState extends State<ExclusiveGrouping> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.exclusiveGrouping,
      children: ExclusiveGroupingType.values
          .map((e) => CheckBoxItem(
                title: e.name,
                value: personalizedPresenter.exclusiveGroupingType == e,
                onTap: () {
                  setState(() {
                    personalizedPresenter.changeExclusiveGroupingType(e);
                  });
                },
              ))
          .toList(),
    );
  }
}
