import 'package:flutter/material.dart';

import '../../main/utils/utils.dart';
import '../helpers/helpers.dart';
import 'components.dart';

class GetNewDate {
  GetNewDate._();

  static Future<DateTime?> get({
    bool? canInsertDateBeforeNow = false,
    bool insertHoursAndMinutes = true,
    int? reduceDaysFromInitialDate,
    DateTime? lastDate,
  }) async {
    DateTime now = DateTime.now();
    final initialDate = now.subtract(
      Duration(days: reduceDaysFromInitialDate ?? 0),
    );

    DateTime? validityDate = await showDatePicker(
      context: NavigatorKey.key.currentState!.context,
      firstDate: initialDate,
      initialDate: now,
      lastDate: lastDate ?? now.add(const Duration(days: 1825)),
      locale: const Locale('pt', 'BR'),
    );

    if (!insertHoursAndMinutes) {
      return validityDate;
    }

    if (validityDate != null) {
      TimeOfDay? newTime = await showTimePicker(
        context: NavigatorKey.key.currentState!.context,
        initialTime: TimeOfDay.now(),
      );

      if (newTime == null) {
        snackBarMessage(
          NavigatorKey.key.currentState!.context,
          R.string.dateNotUpdated,
          Colors.red,
        );
      } else {
        DateTime selectedDateTime = DateTime(
          validityDate.year,
          validityDate.month,
          validityDate.day,
          newTime.hour,
          newTime.minute,
        );

        if (selectedDateTime.isBefore(initialDate) &&
            canInsertDateBeforeNow == false) {
          snackBarMessage(
            NavigatorKey.key.currentState!.context,
            R.string.dateNotUpdated,
            Colors.red,
          );

          return null;
        } else {
          return selectedDateTime;
        }
      }
    }

    return null;
  }
}
