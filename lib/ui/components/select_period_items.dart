// ignore_for_file: library_private_types_in_public_api

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
      return Text("Empty items. You must create items");
    }
    HomePresenter homePresenter = Get.find();

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
        widget.items.where((e) => e.title == selected).first.onTap();
        homePresenter.updateScreen();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.grey[400];
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
