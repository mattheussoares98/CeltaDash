// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SelectPeriod extends StatefulWidget {
  const SelectPeriod({super.key});

  @override
  State<SelectPeriod> createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<PersonalizedPresenter>();

    final now = DateTime.now();
    final startDate = presenter.currentSelectedParams?.startDate;
    final endDate = presenter.currentSelectedParams?.endDate;
    final selectedDateTimeRange = startDate != null && endDate != null
        ? DateTimeRange(start: startDate, end: endDate)
        : null;
    final theme = Theme.of(context);

    return Container(
      color: theme.disabledColor.withAlpha(70),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                R.string.period,
                style: theme.textTheme.bodyMedium,
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
                    setState(() {
                      presenter.changeDateRange(
                        pickedRange.start,
                        pickedRange.end,
                      );
                    });
                  }
                },
                child: _ButtonText(selectedDateRange: selectedDateTimeRange),
              ),
            ),
          ],
        ),
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
