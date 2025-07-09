import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ChangeDatesButtons extends StatelessWidget {
  final DateTime firstDay;
  final DateTime secondDay;
  final bool? isLoading;
  const ChangeDatesButtons({
    super.key,
    required this.firstDay,
    required this.secondDay,
    required this.isLoading,
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
    if (compareDaysPresenter.saleStatistics == null) {
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
            child: ElevatedButton.icon(
              onPressed: isLoading == true
                  ? null
                  : () async {
                      await _updateDate(
                        isFirstDate: true,
                        homePresenter: homePresenter,
                        compareDaysPresenter: compareDaysPresenter,
                      );
                    },
              icon: Icon(
                Platform.isIOS ? CupertinoIcons.calendar : Icons.calendar_month,
                color: Colors.white,
              ),
              label: FittedBox(
                  child: Text(DateFormat.yMd('pt_BR').format(firstDay))),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLoading == true
                  ? null
                  : () async {
                      await _updateDate(
                        isFirstDate: false,
                        homePresenter: homePresenter,
                        compareDaysPresenter: compareDaysPresenter,
                      );
                    },
              icon: Icon(
                Platform.isIOS ? CupertinoIcons.calendar : Icons.calendar_month,
                color: Colors.white,
              ),
              label: FittedBox(
                  child: Text(DateFormat.yMd('pt_BR').format(secondDay))),
            ),
          ),
          if (showRefreshButton(compareDaysPresenter))
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  onPressed: isLoading == true
                      ? null
                      : () async {
                          await compareDaysPresenter.getSales(
                            firstDay: firstDay,
                            secondDay: secondDay,
                            homePresenter: homePresenter,
                            forceRefresh: true,
                          );
                        },
                  icon: isLoading == true
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Icon(Icons.refresh),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
