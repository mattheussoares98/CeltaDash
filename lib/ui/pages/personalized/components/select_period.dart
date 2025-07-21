import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/helpers.dart';

class SelectPeriod extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final void Function(DateTimeRange) changeSelectedDateRange;
  const SelectPeriod({
    super.key,
    required this.selectedDateRange,
    required this.changeSelectedDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);

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
                  initialDateRange: selectedDateRange,
                );

                if (pickedRange != null && pickedRange != selectedDateRange) {
                  changeSelectedDateRange(pickedRange);
                }
              },
              child: _ButtonText(selectedDateRange: selectedDateRange),
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
