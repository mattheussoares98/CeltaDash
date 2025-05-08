import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ChangeDatesButtons extends StatelessWidget {
  final DateTime firstDay;
  final DateTime secondDay;
  const ChangeDatesButtons({
    super.key,
    required this.firstDay,
    required this.secondDay,
  });

  Future<void> _updateDate({
    required bool isFirstDate,
    required HomePresenter homePresenter,
    required CompareDaysPresenter compareDaysPresenter,
  }) async {
    final newDate = await GetNewDate.get(
      canInsertDateBeforeNow: true,
      insertHoursAndMinutes: false,
      lastDate: DateTime.now(),
      reduceDaysFromInitialDate: 365,
    );
    final date = isFirstDate
        ? compareDaysPresenter.selectedFirstDay ?? firstDay
        : compareDaysPresenter.selectedSecondDay ?? secondDay;

    if (newDate != null && newDate != date) {
      await compareDaysPresenter.getSales(
        firstDay: isFirstDate
            ? newDate
            : compareDaysPresenter.selectedFirstDay ?? firstDay,
        secondDay: isFirstDate == false
            ? newDate
            : compareDaysPresenter.selectedSecondDay ?? secondDay,
        homePresenter: homePresenter,
      );

      debugPrint("Changed date");
    }
  }

  @override
  Widget build(BuildContext context) {
    CompareDaysPresenter compareDaysPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                await _updateDate(
                  isFirstDate: true,
                  homePresenter: homePresenter,
                  compareDaysPresenter: compareDaysPresenter,
                );
              },
              child: FittedBox(
                  child: Text(DateFormat.yMd('pt_BR').format(
                      compareDaysPresenter.selectedFirstDay ?? firstDay))),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                await _updateDate(
                  isFirstDate: false,
                  homePresenter: homePresenter,
                  compareDaysPresenter: compareDaysPresenter,
                );
              },
              child: FittedBox(
                  child: Text(DateFormat.yMd('pt_BR').format(
                      compareDaysPresenter.selectedSecondDay ?? secondDay))),
            ),
          ),
        ],
      ),
    );
  }
}
