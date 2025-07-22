import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PeriodGrouping extends StatefulWidget {
  const PeriodGrouping({super.key});

  @override
  State<PeriodGrouping> createState() => _PeriodGroupingState();
}

class _PeriodGroupingState extends State<PeriodGrouping> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: ContainerDecoration.defaultDecoration,
      child: ExpansionTile(
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.all(4),
        backgroundColor: backgroundColor,
        collapsedBackgroundColor: backgroundColor,
        title: Text(R.string.groupPeriod),
        children: PeriodGroupingType.values
            .map(
              (e) => Container(
                decoration: ContainerDecoration.defaultDecoration,
                child: RadioListTile(
                  value: e,
                  toggleable: true,
                  dense: true,
                  groupValue: personalizedPresenter.periodGroupingType,
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
