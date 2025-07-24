import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class PeriodGrouping extends StatefulWidget {
  const PeriodGrouping({super.key});

  @override
  State<PeriodGrouping> createState() => _PeriodGroupingState();
}

class _PeriodGroupingState extends State<PeriodGrouping> {
  PeriodGroupingType? getSelectedPeriod() {
    final params = Get.find<PersonalizedPresenter>().currentSelectedParams;
    if (params == null) return null;

    final selectedCategories = PeriodGroupingType.values
        .where((type) => params.isPeriodSelected(type))
        .toList();

    if (selectedCategories.isEmpty) return null;

    return selectedCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);
    final selectedPeriod = getSelectedPeriod();

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: ContainerDecoration.defaultDecoration,
      child: ExpansionTile(
        initiallyExpanded: false,
        dense: true,
        childrenPadding: const EdgeInsets.all(4),
        backgroundColor: backgroundColor,
        collapsedBackgroundColor: backgroundColor,
        title: Text(
            '${R.string.groupPeriod}${selectedPeriod == null ? '' : " (${selectedPeriod.name})"}'),
        children: PeriodGroupingType.values
            .map(
              (e) => Container(
                decoration: ContainerDecoration.defaultDecoration,
                child: RadioListTile(
                  value: e,
                  toggleable: true,
                  dense: true,
                  groupValue: selectedPeriod,
                  title: Text(e.name),
                  onChanged: (_) {
                    setState(() {
                      personalizedPresenter.changePeriodGroupingType(e);
                    });
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
