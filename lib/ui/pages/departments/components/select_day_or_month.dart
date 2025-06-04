import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../departments.dart';

class SelectDayOrMonth extends StatelessWidget {
  final void Function() onTapSelectDay;
  final void Function() onTapSelectMonth;
  //TODO create a unique widget for all pages
  const SelectDayOrMonth({
    super.key,
    required this.onTapSelectDay,
    required this.onTapSelectMonth,
  });

  @override
  Widget build(BuildContext context) {
    DepartmentsPresenter departmentsPresenter = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SelectPeriodItems(
          indexToSelectWhenRebuild:
              departmentsPresenter.selectedPeriodType == PeriodType.daily
                  ? 0
                  : 1,
          items: [
            SelectPeriodItems.createItem(
              title: R.string.day,
              onTap: onTapSelectDay,
            ),
            SelectPeriodItems.createItem(
              title: R.string.month,
              onTap: onTapSelectMonth,
            ),
          ],
        ),
      ],
    );
  }
}
