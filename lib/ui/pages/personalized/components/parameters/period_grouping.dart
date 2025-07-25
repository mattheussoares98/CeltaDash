import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import '../components.dart';

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
    final selectedPeriod = getSelectedPeriod();

    return DefaultExpansionTile(
      title: Text(
        '${R.string.groupPeriod}${selectedPeriod == null ? '' : " (${selectedPeriod.name})"}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      children: PeriodGroupingType.values
          .map(
            (e) => RadioListTile(
              contentPadding: const EdgeInsets.all(0),
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
          )
          .toList(),
    );
  }
}
