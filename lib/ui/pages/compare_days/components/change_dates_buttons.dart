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
    final date = isFirstDate ? firstDay : secondDay;

    if (newDate != null && newDate != date) {
      await compareDaysPresenter.getSales(
        firstDay: isFirstDate ? newDate : firstDay,
        secondDay: isFirstDate == false ? newDate : secondDay,
        homePresenter: homePresenter,
      );

      debugPrint("Changed date");
    }
  }

  bool showRefreshButton(CompareDaysPresenter compareDaysPresenter) {
    final now = DateTime.now();
    if (compareDaysPresenter.saleMovements == null) {
      return true;
    } else if (firstDay.day == now.day &&
        firstDay.month == now.month &&
        firstDay.year == now.year) {
      return true;
    } else if (secondDay.day == now.day &&
        secondDay.month == now.month &&
        secondDay.year == now.year) {
      return true;
    } else {
      return false;
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
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await _updateDate(
                  isFirstDate: true,
                  homePresenter: homePresenter,
                  compareDaysPresenter: compareDaysPresenter,
                );
              },
              child: FittedBox(
                  child: Text(DateFormat.yMd('pt_BR').format(firstDay))),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await _updateDate(
                  isFirstDate: false,
                  homePresenter: homePresenter,
                  compareDaysPresenter: compareDaysPresenter,
                );
              },
              child: FittedBox(
                  child: Text(DateFormat.yMd('pt_BR').format(secondDay))),
            ),
          ),
          if (showRefreshButton(compareDaysPresenter))
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () async {
                  await compareDaysPresenter.getSales(
                    firstDay: firstDay,
                    secondDay: secondDay,
                    homePresenter: homePresenter,
                  );
                },
                icon: Icon(Icons.refresh),
              ),
            ),
        ],
      ),
    );
  }
}
