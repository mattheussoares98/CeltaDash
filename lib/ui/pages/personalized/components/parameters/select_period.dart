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
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);
    final selectedDateTimeRange = presenter.startDate != null &&
            presenter.endDate != null
        ? DateTimeRange(start: presenter.startDate!, end: presenter.endDate!)
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
