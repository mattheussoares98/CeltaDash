import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';

class SelectDateButton extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime date) updateDate;
  const SelectDateButton({
    super.key,
    required this.date,
    required this.updateDate,
  });

  void _updateDate(bool isFirstDate) async {
    final newDate = await GetNewDate.get(
      canInsertDateBeforeNow: true,
      insertHoursAndMinutes: false,
      lastDate: DateTime.now(),
      reduceDaysFromInitialDate: 365,
    );
    if (newDate != null) {
      updateDate(newDate);
      debugPrint("Changed date");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _updateDate(true);
      },
      child: FittedBox(child: Text(DateFormat.yMd('pt_BR').format(date))),
    );
  }
}
