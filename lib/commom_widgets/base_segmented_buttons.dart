import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/entities/entities.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseSegmentedButtons<T extends SelectableItem<T>>
    extends StatelessWidget {
  const BaseSegmentedButtons({
    super.key,
    required this.items, //TODO delete this widget
    required this.selectedValue,
    required this.onChanged,
  });

  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (items.length == 1) {
      final singleItem = items.first;
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p8,
        ),
        decoration: BoxDecoration(
          color: singleItem.color ?? context.theme.primaryColor,
          borderRadius: BorderRadius.circular(Sizes.p8),
        ),
        child: BaseText(singleItem.name, color: Colors.white),
      );
    }

    final selectedItem = items.cast<T?>().firstWhere(
      (item) => item?.value == selectedValue,
      orElse: () => items.first,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoSlidingSegmentedControl<T>(
          groupValue: selectedValue,
          onValueChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },

          thumbColor: selectedItem?.color ?? context.theme.primaryColor,

          children: {
            for (var item in items)
              item.value: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      (constraints.maxWidth /
                              items.length /
                              (item.name.isEmpty ? 1 : item.name.length)) >
                          20
                      ? Sizes.p20
                      : Sizes.p4,
                  vertical: Sizes.p8,
                ),
                child: FittedBox(
                  child: BaseText(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    color: selectedValue == item.value
                        ? Colors.white
                        : CupertinoColors.black,
                  ),
                ),
              ),
          },
        );
      },
    );
  }
}
