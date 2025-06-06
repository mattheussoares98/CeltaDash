// ignore_for_file: library_private_types_in_public_api

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../helpers/helpers.dart';
import '../pages/pages.dart';

class SelectPeriodItems extends StatefulWidget {
  final PeriodType? selectedPeriodType;
  final bool? isLoading;
  final void Function()? onTapDaily;
  final void Function()? onTapWeekly;
  final void Function()? onTapMonthly;
  final void Function()? onTapYearly;
  const SelectPeriodItems({
    super.key,
    required this.selectedPeriodType,
    required this.isLoading,
    this.onTapDaily,
    this.onTapWeekly,
    this.onTapMonthly,
    this.onTapYearly,
  });

  static _PeriodItem createItem({
    required String title,
    required void Function() onTap,
  }) {
    return _PeriodItem(title: title, onTap: onTap);
  }

  @override
  State<SelectPeriodItems> createState() => _PeriodItems();
}

class _PeriodItems extends State<SelectPeriodItems> {
  String? selected;

  List<_PeriodItem> get items => <_PeriodItem>[
        if (widget.onTapDaily != null)
          _PeriodItem(title: R.string.day, onTap: widget.onTapDaily!),
        if (widget.onTapWeekly != null)
          _PeriodItem(title: R.string.week, onTap: widget.onTapWeekly!),
        if (widget.onTapMonthly != null)
          _PeriodItem(title: R.string.month, onTap: widget.onTapMonthly!),
        if (widget.onTapYearly != null)
          _PeriodItem(title: R.string.year, onTap: widget.onTapYearly!),
      ];

  int get selectedItemIndex {
    if (widget.selectedPeriodType == PeriodType.daily &&
        widget.onTapDaily != null) {
      return items.indexWhere((e) => e.title == R.string.day);
    } else if (widget.selectedPeriodType == PeriodType.weekly &&
        widget.onTapWeekly != null) {
      return items.indexWhere((e) => e.title == R.string.week);
    } else if (widget.selectedPeriodType == PeriodType.monthly &&
        widget.onTapMonthly != null) {
      return items.indexWhere((e) => e.title == R.string.month);
    } else if (widget.selectedPeriodType == PeriodType.yearly &&
        widget.onTapYearly != null) {
      return items.indexWhere((e) => e.title == R.string.year);
    } else {
      return 0;
    }
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
    if (widget.onTapDaily == null &&
        widget.onTapWeekly == null &&
        widget.onTapMonthly == null &&
        widget.onTapYearly == null) {
      return const Text(
          "Empty items. You must pass the functions for each item that wants enable");
    }

    HomePresenter homePresenter = Get.find();

    if (Platform.isIOS) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: CupertinoSlidingSegmentedControl<String>(
          children: {
            for (var item in items)
              item.title: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            homePresenter.updateScreen();
          },
        ),
      );
    }

    return SegmentedButton<String>(
      segments: List.generate(items.length, (i) {
        return ButtonSegment(
          value: items[i].title,
          label: FittedBox(child: Text(items[i].title)),
        );
      }),
      selected: {selected!},
      showSelectedIcon: false,
      onSelectionChanged: (newSelection) {
        if (widget.isLoading == true) return;
        setState(() {
          selected = newSelection.first;
        });
        items.firstWhere((e) => e.title == selected).onTap();
        homePresenter.updateScreen();
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (widget.isLoading == true) return Colors.grey;
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Theme.of(context).primaryColorDark;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).primaryColorDark;
          }
          return Colors.white;
        }),
      ),
    );
  }
}

class _PeriodItem {
  final String title;
  final void Function() onTap;
  _PeriodItem({required this.title, required this.onTap});
}
