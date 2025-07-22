// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PeriodGroupsItems extends StatefulWidget {
  const PeriodGroupsItems({super.key});

  @override
  State<PeriodGroupsItems> createState() => _PeriodItems();
}

class _PeriodItems extends State<PeriodGroupsItems> {
  final personalizedPresenter = Get.find<PersonalizedPresenter>();
  String? selected;

  List<_PeriodItem> get items => <_PeriodItem>[
        _PeriodItem(
          title: R.string.hour,
          onTap: () => personalizedPresenter
              .changePeriodGroupingType(PeriodGroupingType.hour),
          periodGroupingType: PeriodGroupingType.hour,
        ),
        _PeriodItem(
          title: R.string.day,
          onTap: () => personalizedPresenter
              .changePeriodGroupingType(PeriodGroupingType.day),
          periodGroupingType: PeriodGroupingType.day,
        ),
        _PeriodItem(
          title: R.string.month,
          onTap: () => personalizedPresenter
              .changePeriodGroupingType(PeriodGroupingType.month),
          periodGroupingType: PeriodGroupingType.month,
        ),
        _PeriodItem(
          title: R.string.year,
          onTap: () => personalizedPresenter
              .changePeriodGroupingType(PeriodGroupingType.year),
          periodGroupingType: PeriodGroupingType.year,
        ),
      ];

  int get selectedItemIndex {
    final index = items.indexWhere((e) =>
        e.periodGroupingType ==
        Get.find<PersonalizedPresenter>().periodGroupingTypes.first);
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
    return Padding(
      padding: const EdgeInsets.all(4),
      child: CupertinoSlidingSegmentedControl<String>(
        children: {
          for (var item in items)
            item.title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                item.title,
                selectionColor: (selected == item.title
                    ? CupertinoColors.white
                    : Theme.of(context).primaryColorDark),
                style: TextStyle(
                  color: (selected == item.title
                      ? CupertinoColors.white
                      : Theme.of(context).primaryColor),
                ),
              ),
            ),
        },
        groupValue: selected,
        thumbColor: Theme.of(context).primaryColorDark,
        backgroundColor: Theme.of(context).disabledColor.withAlpha(40),
        onValueChanged: (newValue) {
          if (newValue == null) return;
          selected = newValue;
          items.firstWhere((e) => e.title == newValue).onTap();
        },
      ),
    );
  }
}

class _PeriodItem {
  final String title;
  final VoidCallback onTap;
  final PeriodGroupingType periodGroupingType;
  _PeriodItem({
    required this.title,
    required this.onTap,
    required this.periodGroupingType,
  });
}
