import 'dart:io';

import 'package:flutter/cupertino.dart';
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

    DateTime? selectedDate;

    if (Platform.isIOS) {
      selectedDate = await _showCupertinoDatePicker(
        initialDate: initialDate,
        lastDate: lastDate ?? now.add(Duration(days: 1825)),
      );
    } else {
      selectedDate = await showDatePicker(
        context: NavigatorKey.key.currentState!.context,
        firstDate: initialDate,
        initialDate: now,
        lastDate: lastDate ?? now.add(Duration(days: 1825)),
        locale: const Locale('pt', 'BR'),
      );
    }

    if (selectedDate == null || !insertHoursAndMinutes) return selectedDate;

    TimeOfDay? selectedTime;

    if (Platform.isIOS) {
      selectedTime = await _showCupertinoTimePicker();
    } else {
      selectedTime = await showTimePicker(
        context: NavigatorKey.key.currentState!.context,
        initialTime: TimeOfDay.now(),
      );
    }

    if (selectedTime == null) {
      snackBarMessage(
        NavigatorKey.key.currentState!.context,
        R.string.dateNotUpdated,
        Colors.red,
      );
      return null;
    }

    final finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (finalDateTime.isBefore(initialDate) &&
        canInsertDateBeforeNow == false) {
      snackBarMessage(
        NavigatorKey.key.currentState!.context,
        R.string.dateNotUpdated,
        Colors.red,
      );
      return null;
    }

    return finalDateTime;
  }

  static Future<DateTime?> _showCupertinoDatePicker({
    required DateTime initialDate,
    required DateTime lastDate,
  }) async {
    DateTime? tempPickedDate = lastDate;

    return await showCupertinoModalPopup<DateTime>(
      context: NavigatorKey.key.currentState!.context,
      builder: (BuildContext context) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: Theme.of(context).primaryColorDark,
            textTheme: CupertinoTextThemeData(
              pickerTextStyle: TextStyle(
                color: Theme.of(context).disabledColor.withAlpha(40),
                fontSize: 20,
              ),
              dateTimePickerTextStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 20,
              ),
            ),
          ),
          child: Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: lastDate,
                    minimumDate: initialDate,
                    maximumDate: lastDate,
                    onDateTimeChanged: (DateTime newDate) {
                      tempPickedDate = newDate;
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(tempPickedDate),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<TimeOfDay?> _showCupertinoTimePicker() async {
    DateTime now = DateTime.now();
    DateTime pickedDateTime = now;

    return await showCupertinoModalPopup<TimeOfDay>(
      context: NavigatorKey.key.currentState!.context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: now,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDateTime) {
                    pickedDateTime = newDateTime;
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(
                    TimeOfDay(
                        hour: pickedDateTime.hour,
                        minute: pickedDateTime.minute),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
