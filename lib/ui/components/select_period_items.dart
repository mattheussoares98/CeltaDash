// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/helpers/helpers.dart';
import '../helpers/helpers.dart';

class SelectPeriodItems extends StatefulWidget {
  final PeriodType? selectedPeriodType;
  final bool? isLoading;
  final void Function()? onTapHourly;
  final void Function()? onTapDaily;
  final void Function()? onTapWeekly;
  final void Function()? onTapMonthly;
  final void Function()? onTapYearly;
  const SelectPeriodItems({
    super.key,
    required this.selectedPeriodType,
    required this.isLoading,
    this.onTapHourly,
    this.onTapDaily,
    this.onTapWeekly,
    this.onTapMonthly,
    this.onTapYearly,
  });

  @override
  State<SelectPeriodItems> createState() => _PeriodItems();
}

class _PeriodItems extends State<SelectPeriodItems> {
  String? selected;

  List<_PeriodItem> get items => <_PeriodItem>[
        if (widget.onTapHourly != null)
          _PeriodItem(
            title: R.string.hour,
            onTap: widget.onTapHourly!,
            periodType: PeriodType.hourly,
          ),
        if (widget.onTapDaily != null)
          _PeriodItem(
            title: R.string.day,
            onTap: widget.onTapDaily!,
            periodType: PeriodType.daily,
          ),
        if (widget.onTapWeekly != null)
          _PeriodItem(
            title: R.string.week,
            onTap: widget.onTapWeekly!,
            periodType: PeriodType.weekly,
          ),
        if (widget.onTapMonthly != null)
          _PeriodItem(
            title: R.string.month,
            onTap: widget.onTapMonthly!,
            periodType: PeriodType.monthly,
          ),
        if (widget.onTapYearly != null)
          _PeriodItem(
            title: R.string.year,
            onTap: widget.onTapYearly!,
            periodType: PeriodType.yearly,
          ),
      ];

  int get selectedItemIndex {
    final index =
        items.indexWhere((e) => e.periodType == widget.selectedPeriodType);
    return index != -1 ? index : 0;
  }

  @override
  void initState() {
    super.initState();

    if (items.isNotEmpty) {
      selected = items[selectedItemIndex].title;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTapHourly == null &&
        widget.onTapDaily == null &&
        widget.onTapWeekly == null &&
        widget.onTapMonthly == null &&
        widget.onTapYearly == null) {
      return const Text(
          "Empty items. You must pass the functions for each item that wants enable");
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoSlidingSegmentedControl<String>(
        children: {
          for (var item in items)
            item.title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                item.title,
                selectionColor: widget.isLoading == true
                    ? CupertinoColors.inactiveGray
                    : (selected == item.title
                        ? CupertinoColors.white
                        : Theme.of(context).primaryColorDark),
                style: TextStyle(
                  color: widget.isLoading == true && selected != item.title
                      ? CupertinoColors.inactiveGray
                      : (selected == item.title
                          ? CupertinoColors.white
                          : Theme.of(context).primaryColor),
                ),
              ),
            ),
        },
        groupValue: selected,
        thumbColor: widget.isLoading == true
            ? CupertinoColors.systemGrey
            : Theme.of(context).primaryColorDark,
        backgroundColor: Theme.of(context).disabledColor.withAlpha(40),
        onValueChanged: (newValue) {
          if (newValue == null || widget.isLoading == true) return;
          selected = newValue;
          items.firstWhere((e) => e.title == newValue).onTap();
        },
      ),
    );
  }
}

class _PeriodItem {
  final String title;
  final void Function() onTap;
  final PeriodType periodType;
  _PeriodItem({
    required this.title,
    required this.onTap,
    required this.periodType,
  });
}
