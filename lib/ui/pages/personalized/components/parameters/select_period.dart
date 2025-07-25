// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    final startDate = presenter.currentSelectedParams?.startDate;
    final endDate = presenter.currentSelectedParams?.endDate;
    final selectedDateTimeRange = startDate != null && endDate != null
        ? DateTimeRange(start: startDate, end: endDate)
        : null;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(
              Platform.isIOS ? Icons.calendar_today : Icons.date_range_outlined,
            ),
            iconAlignment: IconAlignment.end,
            label: _ButtonText(selectedDateRange: selectedDateTimeRange),
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
                widget.enterprisesController.expand();
              }
            },
          ),
        ),
      ],
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
          "${R.string.period} ${formatter.format(selectedDateRange!.start)} ~ ${formatter.format(selectedDateRange!.end)}");
    }

    return Text(R.string.msgSelectPeriod);
  }
}
