import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class SummaryTableItem {
  final String title;
  final dynamic value;
  final bool isPrice;
  final bool isPercentage;
  final int decimalHouses;
  final Color? color;
  final Widget? trailing;

  SummaryTableItem({
    required this.title,
    required this.value,
    this.isPrice = false,
    this.isPercentage = false,
    this.decimalHouses = 2,
    this.color,
    this.trailing,
  });
}

class SummaryTable extends StatelessWidget {
  final List<SummaryTableItem> items;
  final MainAxisAlignment mainAxisAlignment;
  const SummaryTable({
    super.key,
    required this.items,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = context.theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: List.generate(items.length, (index) {
          final item = items[index];
          String formattedValue = item.value.toString();
          String? priceText;

          if (item.value is num) {
            if (item.isPrice) {
              priceText = item.value.toString().toBRL(
                item.decimalHouses,
              );
            } else if (item.isPercentage) {
              formattedValue =
                  '${item.value.toString().toBRL(item.decimalHouses)} %';
            } else {
              formattedValue = item.value.toString().toBRL(
                item.decimalHouses,
                true,
              );
            }
          }

          final effectiveValueStyle = item.color != null
              ? valueStyle?.copyWith(color: item.color)
              : valueStyle;

          var alignment = Alignment.center;
          var mainAxisAlignment = MainAxisAlignment.center;

          if (items.length > 2) {
            if (index == 0) {
              alignment = Alignment.centerLeft;
              mainAxisAlignment = MainAxisAlignment.start;
            } else if (index == items.length - 1) {
              alignment = Alignment.centerRight;
              mainAxisAlignment = MainAxisAlignment.end;
            }
          }

          return Flexible(
            child: Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                Align(
                  alignment: alignment,
                  child: Row(
                    mainAxisAlignment: mainAxisAlignment,
                    crossAxisAlignment: .start,
                    children: [
                      Flexible(
                        child: BaseText.caption(
                          item.title,
                          fontWeight: FontWeight.bold,
                          color: context.theme.hintColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.trailing != null) ...[gapW4, item.trailing!],
                    ],
                  ),
                ),
                if (priceText != null)
                  Align(
                    alignment: alignment,
                    child: AnimatedPriceValue(
                      key: ValueKey(item.title),
                      value: item.value as num,
                      style: effectiveValueStyle,
                      priceText: priceText,
                    ),
                  )
                else
                  Align(
                    alignment: alignment,
                    child: BaseText.bodyMedium(
                      formattedValue,
                      fontWeight: FontWeight.bold,
                      color: item.color,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
