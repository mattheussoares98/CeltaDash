import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SelectDayOrMonthButtons extends StatelessWidget {
  final void Function() onTapMonthly;
  final void Function() onTapDaily;
  const SelectDayOrMonthButtons({
    super.key,
    required this.onTapMonthly,
    required this.onTapDaily,
  });

  @override
  Widget build(BuildContext context) {
    PaymentTypePresenter paymentTypePresenter = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectPeriodItems(
          indexToSelectWhenRebuild:
              paymentTypePresenter.selectedPeriodType == PeriodType.daily
                  ? 0
                  : 1,
          items: [
            SelectPeriodItems.createItem(
              title: R.string.day,
              onTap: onTapDaily,
            ),
            SelectPeriodItems.createItem(
              title: R.string.month,
              onTap: onTapMonthly,
            ),
          ],
        ),
      ],
    );
  }
}
