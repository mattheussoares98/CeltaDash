import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../../domain/usecases/usecases.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import '../components.dart';

class PeriodGrouping extends StatefulWidget {
  final ExpansibleController periodsController;
  final ExpansibleController categoriesController;
  final void Function(bool collapseParameters) collapseAll;
  const PeriodGrouping({
    super.key,
    required this.periodsController,
    required this.categoriesController,
    required this.collapseAll,
  });

  @override
  State<PeriodGrouping> createState() => _PeriodGroupingState();
}

class _PeriodGroupingState extends State<PeriodGrouping> {
  void changeValue(PersonalizedPresenter presenter, PeriodGroupingType e) {
    setState(() {
      presenter.changePeriodGroupingType(e);
    });
    widget.collapseAll(false);
    widget.categoriesController.expand();
  }

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    final selectedPeriod =
        personalizedPresenter.currentSelectedParams?.selectedPeriod;

    return DefaultExpansionTile(
      controller: widget.periodsController,
      title: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(text: R.string.groupPeriod),
            if (selectedPeriod != null)
              TextSpan(
                text: " (${selectedPeriod.name})",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      children: PeriodGroupingType.values
          .map(
            (e) => InkWell(
              onTap: () {
                changeValue(personalizedPresenter, e);
              },
              child: RadioGroup(
                groupValue: selectedPeriod,
                child: Row(
                  children: [
                    Radio(value: e),
                    Expanded(child: Text(e.name)),
                  ],
                ),
                onChanged: (_) {
                  changeValue(personalizedPresenter, e);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
