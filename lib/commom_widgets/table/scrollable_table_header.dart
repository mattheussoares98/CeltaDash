part of 'scrollable_table.dart';

/// Intentionally a private constant so it is never recreated.
const _kUnsortedIconColor = Color(0x78808080); // grey with alpha 120

class _ScrollableTableHeaderCell<T> extends StatelessWidget {
  final ScrollableTableColumnSpec<T> spec;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback? onTap;

  const _ScrollableTableHeaderCell({
    required this.spec,
    required this.isSorted,
    required this.sortAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final canSort = spec.sortValueMapper != null;
    final sortIconColor = canSort && isSorted
        ? context.theme.primaryColor
        : _kUnsortedIconColor;
    final cupertinoSortIcon = sortAscending
        ? CupertinoIcons.arrow_up
        : CupertinoIcons.arrow_down;
    final materialSortIcon = sortAscending
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return InkWell(
      onTap: canSort ? onTap : null,
      child: Stack(
        children: [
          Center(
            child: BaseRichText(
              textAlign: TextAlign.center,
              texts: [
                BaseText.title(spec.headerTitle, textAlign: TextAlign.center),
                if (spec.isMoney == true)
                  BaseText.caption(' R\$', textAlign: TextAlign.center),
                if (spec.isPercentage == true)
                  BaseText.caption(' %', textAlign: TextAlign.center),
              ],
            ),
          ),
          if (canSort) ...[
            Positioned(
              bottom: Sizes.p4,
              right: 0,
              child: PlatformIcon(
                cupertinoIcon: isSorted
                    ? cupertinoSortIcon
                    : CupertinoIcons.arrow_up,
                materialIcon: isSorted ? materialSortIcon : Icons.arrow_upward,
                color: sortIconColor,
                size: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
