// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SelectPeriod extends StatefulWidget {
  final ExpansibleController enterprisesController;
  const SelectPeriod({super.key, required this.enterprisesController});

  @override
  State<SelectPeriod> createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<PersonalizedPresenter>();

    final now = DateTime.now();

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final start = await GetNewDate.get(
                canInsertDateBeforeNow: true,
                insertHoursAndMinutes: false,
                lastDate: now,
                reduceDaysFromInitialDate: 1100,
              );
              setState(() {
                presenter.changeDateRange(start, null);
              });
            },
            label: _ButtonText(isStartDate: true, date: presenter.startDate),
            icon: Icon(
              Platform.isIOS ? Icons.calendar_today : Icons.date_range_outlined,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final end = await GetNewDate.get(
                canInsertDateBeforeNow: true,
                insertHoursAndMinutes: false,
                lastDate: now,
                reduceDaysFromInitialDate: 1100,
              );
              setState(() {
                presenter.changeDateRange(null, end);
              });
            },
            label: _ButtonText(isStartDate: false, date: presenter.endDate),
            icon: Icon(
              Platform.isIOS ? Icons.calendar_today : Icons.date_range_outlined,
            ),
          ),
        ),
      ],
    );
  }
}

class _ButtonText extends StatelessWidget {
  final DateTime? date;
  final bool isStartDate;
  const _ButtonText({required this.isStartDate, required this.date});

  @override
  Widget build(BuildContext context) {
    if (date != null) {
      final formatter = DateFormat.yMd("pt_BR");

      return Text(formatter.format(date!), maxLines: 1);
    }

    return Text(isStartDate ? R.string.start : R.string.end);
  }
}
