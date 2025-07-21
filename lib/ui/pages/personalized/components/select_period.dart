import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SelectPeriod extends StatelessWidget {
  const SelectPeriod({super.key});

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    final now = DateTime.now();
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);
    final selectedDateTimeRange = personalizedPresenter.startDate != null &&
            personalizedPresenter.endDate != null
        ? DateTimeRange(
            start: personalizedPresenter.startDate!,
            end: personalizedPresenter.endDate!)
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: ContainerDecoration.defaultDecoration.copyWith(
        color: backgroundColor,
        boxShadow: [],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              R.string.period,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final DateTimeRange? pickedRange = await showDateRangePicker(
                  locale: const Locale('pt', 'BR'),
                  context: context,
                  firstDate: now.subtract(const Duration(days: 365 * 3)),
                  lastDate: now,
                  initialDateRange: selectedDateTimeRange,
                );

                if (pickedRange != null) {
                  personalizedPresenter.changeSelectedDateRange(
                    pickedRange.start,
                    pickedRange.end,
                  );
                }
              },
              child: _ButtonText(selectedDateRange: selectedDateTimeRange),
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonText extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  const _ButtonText({required this.selectedDateRange});

  @override
  Widget build(BuildContext context) {
    if (selectedDateRange?.start != null && selectedDateRange?.end != null) {
      final formatter = DateFormat.yMd("pt_BR");

      return Text(
          "${formatter.format(selectedDateRange!.start)} ~ ${formatter.format(selectedDateRange!.end)}");
    }

    return Text(R.string.select);
  }
}
