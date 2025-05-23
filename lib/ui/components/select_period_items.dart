// ignore_for_file: library_private_types_in_public_api

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/pages.dart';

class SelectPeriodItems extends StatefulWidget {
  final List<_PeriodItem> items;
  const SelectPeriodItems({super.key, required this.items});

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

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      selected = widget.items.first.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Text("Empty items. You must create items");
    }

    HomePresenter homePresenter = Get.find();

    if (Platform.isIOS) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: CupertinoSlidingSegmentedControl<String>(
          children: {
            for (var item in widget.items)
              item.title: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  item.title,
                  selectionColor: selected == item.title
                      ? CupertinoColors.white
                      : Theme.of(context).primaryColorDark,
                  style: TextStyle(
                    color: selected == item.title
                        ? CupertinoColors.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
          },
          groupValue: selected,
          thumbColor: Theme.of(context).primaryColorDark,
          backgroundColor: Theme.of(context).primaryColorLight.withAlpha(40),
          onValueChanged: (newValue) {
            if (newValue == null) return;
            selected = newValue;
            widget.items.firstWhere((e) => e.title == newValue).onTap();
            homePresenter.updateScreen();
          },
        ),
      );
    }

    return SegmentedButton<String>(
      segments: List.generate(widget.items.length, (i) {
        return ButtonSegment(
          value: widget.items[i].title,
          label: FittedBox(child: Text(widget.items[i].title)),
        );
      }),
      selected: {selected!},
      showSelectedIcon: false,
      onSelectionChanged: (newSelection) {
        setState(() {
          selected = newSelection.first;
        });
        widget.items.firstWhere((e) => e.title == selected).onTap();
        homePresenter.updateScreen();
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
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
