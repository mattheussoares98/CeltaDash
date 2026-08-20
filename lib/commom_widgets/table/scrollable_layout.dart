part of 'scrollable_table.dart';

class _ScrollableLayout<T> extends StatelessWidget {
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<T> sortedItems;
  final double totalMinWidth;
  final double extraPerColumn;
  final double headerHeight;
  final double rowHeight;
  final double footerHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? footerBackgroundColor;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int) onHeaderTap;
  final bool hasFooter;
  final ScrollController? horizontalScrollController;
  final ScrollPhysics? physics;
  final void Function(T item)? onTapRow;
  final Color? Function(T item)? rowColor;
  final bool fitsInAvailableHeight;

  const _ScrollableLayout({
    required this.columns,
    required this.sortedItems,
    required this.totalMinWidth,
    required this.extraPerColumn,
    required this.headerHeight,
    required this.rowHeight,
    required this.footerHeight,
    required this.headerBackgroundColor,
    required this.rowBackgroundColor,
    required this.footerBackgroundColor,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onHeaderTap,
    required this.hasFooter,
    required this.onTapRow,
    required this.rowColor,
    required this.fitsInAvailableHeight,
    this.horizontalScrollController,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final double totalWidth = totalMinWidth + (extraPerColumn * columns.length);
    final theme = context.theme;
    final Color headerBg =
        headerBackgroundColor ?? theme.disabledColor.withAlpha(30);

    final baseCardColor = rowBackgroundColor ?? theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;
    final evenRowBg = baseCardColor;
    final oddRowBg = isDark
        ? Color.alphaBlend(const Color(0x0CFFFFFF), baseCardColor)
        : Color.alphaBlend(const Color(0x0A000000), baseCardColor);

    Widget buildList() {
      final list = ListView.builder(
        physics: physics,
        padding: EdgeInsets.zero,
        itemCount: sortedItems.length,
        itemExtent: rowHeight,
        itemBuilder: (_, index) {
          final item = sortedItems[index];
          final rowBg = _resolveRowBackgroundColor<T>(
            index: index,
            rowColor: rowColor,
            item: item,
            evenRowBg: evenRowBg,
            oddRowBg: oddRowBg,
          );
          return _ScrollableRow<T>(
            item: item,
            columns: columns,
            rowHeight: rowHeight,
            backgroundColor: rowBg,
            extraPerColumn: extraPerColumn,
            onTapRow: onTapRow,
            showTapIndicator: true,
          );
        },
      );

      if (fitsInAvailableHeight) {
        return SizedBox(height: sortedItems.length * rowHeight, child: list);
      }
      return Expanded(child: list);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: horizontalScrollController,
      physics: const ClampingScrollPhysics(),
      child: SizedBox(
        width: totalWidth,
        child: Column(
          mainAxisSize: fitsInAvailableHeight
              ? MainAxisSize.min
              : MainAxisSize.max,
          children: [
            Row(
              children: [
                for (int i = 0; i < columns.length; i++)
                  _ScrollableHeaderCellWrapper<T>(
                    col: columns[i],
                    colWidth: columns[i].effectiveMinWidth + extraPerColumn,
                    headerHeight: headerHeight,
                    headerBg: headerBg,
                    isSorted: sortColumnIndex == i,
                    sortAscending: sortAscending,
                    onTap: () => onHeaderTap(i),
                  ),
              ],
            ),
            buildList(),
            if (hasFooter)
              SizedBox(
                height: footerHeight,
                child: Row(
                  children: [
                    for (int i = 0; i < columns.length; i++)
                      _ScrollableTableCell(
                        showTopBorder: true,
                        width: columns[i].effectiveMinWidth + extraPerColumn,
                        height: footerHeight,
                        spec: columns[i],
                        backgroundColor: footerBackgroundColor ?? headerBg,
                        child:
                            columns[i].footerCellBuilder?.call(sortedItems) ??
                            const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
