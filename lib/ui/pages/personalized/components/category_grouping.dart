import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class CategoryGrouping extends StatefulWidget {
  const CategoryGrouping({super.key});

  @override
  State<CategoryGrouping> createState() => _CategoryGroupingState();
}

class _CategoryGroupingState extends State<CategoryGrouping> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.exclusiveGrouping,
      itemAboveChildren: const PeriodGroupsItems(),
      children: CategoryGroupingType.values
          .map((e) => CheckBoxItem(
                title: e.name,
                value: personalizedPresenter.categoryGroupingType == e,
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
