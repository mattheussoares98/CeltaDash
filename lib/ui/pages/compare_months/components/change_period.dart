import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChangePeriod extends StatelessWidget {
  final int month;
  final int year;
  final void Function(int?)? onMonthChanged;
  final void Function(int?)? onYearChanged;
  final String title;
  const ChangePeriod({
    super.key,
    required this.month,
    required this.year,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              items: List.generate(12, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(DateFormat.MMMM('pt_BR')
                      .format(DateTime(0, index + 1))
                      .toString()),
                );
              }),
              hint: Text(DateFormat.MMMM('pt_BR').format(DateTime(0, month))),
              onChanged: onMonthChanged,
            ),
            DropdownButton(
              items: List.generate(5, (index) {
                final year = DateTime.now().year - index;
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              value: year,
              hint: Text(year.toString()),
              onChanged: onYearChanged,
            ),
          ],
        ),
      ],
    );
  }
}
