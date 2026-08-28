part of 'scrollable_table.dart';

class _FixedLayout<T> extends StatelessWidget {
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<ScrollableTableColumnSpec<T>> scrollableColumns;
  final List<T> sortedItems;
  final double extraPerColumn;
  final double headerHeight;
  final double rowHeight;
  final double footerHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? footerBackgroundColor;
  final ScrollController fixedVerticalController;
  final ScrollController scrollableVerticalController;
  final ScrollController? horizontalScrollController;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int) onHeaderTap;
  final bool hasFooter;
  final ScrollPhysics? physics;
  final void Function(T item)? onTapRow;
  final Color? Function(T item)? rowColor;
  final bool fitsInAvailableHeight;
  final VoidCallback? onPdfTap;

  const _FixedLayout({
    required this.columns,
    required this.scrollableColumns,
    required this.sortedItems,
    required this.extraPerColumn,
    required this.headerHeight,
    required this.rowHeight,
    required this.footerHeight,
    required this.headerBackgroundColor,
    required this.rowBackgroundColor,
    required this.footerBackgroundColor,
    required this.fixedVerticalController,
    required this.scrollableVerticalController,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onHeaderTap,
    required this.hasFooter,
    required this.physics,
    required this.onTapRow,
    required this.rowColor,
    required this.fitsInAvailableHeight,
    this.horizontalScrollController,
    this.onPdfTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstCol = columns.first;
    final double firstColBaseWidth = onPdfTap != null
        ? math.max(firstCol.effectiveMinWidth, 85.0)
        : firstCol.effectiveMinWidth;
    final double firstColWidth = firstColBaseWidth + extraPerColumn;
    final theme = context.theme;
    final Color headerBg =
        headerBackgroundColor ?? theme.disabledColor.withAlpha(30);
    final double scrollableWidth = scrollableColumns.fold(
      0.0,
      (sum, col) => sum + col.effectiveMinWidth + extraPerColumn,
    );

    final baseCardColor = rowBackgroundColor ?? theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;
    final evenRowBg = baseCardColor;
    final oddRowBg = isDark
        ? Color.alphaBlend(const Color(0x0CFFFFFF), baseCardColor)
        : Color.alphaBlend(const Color(0x0A000000), baseCardColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed column
        SizedBox(
          width: firstColWidth,
          child: Column(
            mainAxisSize: fitsInAvailableHeight
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: [
              _ScrollableTableCell(
                width: firstColWidth,
                height: headerHeight,
                spec: firstCol,
                backgroundColor: headerBg,
                showBottomBorder: true,
                child: _ScrollableTableHeaderCell<T>(
                  spec: firstCol,
                  isSorted: sortColumnIndex == 0,
                  sortAscending: sortAscending,
                  onTap: () => onHeaderTap(0),
                  onPdfTap: onPdfTap,
                ),
              ),
              () {
                final list = ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: ListView.builder(
                    controller: fixedVerticalController,
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
                      Widget cell = _ScrollableTableCell(
                        width: firstColWidth,
                        height: rowHeight,
                        spec: firstCol,
                        backgroundColor: rowBg,
                        child: firstCol.cellBuilder(item),
                      );
                      if (onTapRow != null) {
                        cell = _TappableRowIndicator(child: cell);
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTapRow!(sortedItems[index]),
                          child: cell,
                        );
                      }
                      return cell;
                    },
                  ),
                );

                if (fitsInAvailableHeight) {
                  return SizedBox(
                    height: sortedItems.length * rowHeight,
                    child: list,
                  );
                }
                return Expanded(child: list);
              }(),
              if (hasFooter)
                _ScrollableTableCell(
                  showTopBorder: true,
                  width: firstColWidth,
                  height: footerHeight,
                  spec: firstCol,
                  backgroundColor: footerBackgroundColor ?? headerBg,
                  child:
                      firstCol.footerCellBuilder?.call(sortedItems) ??
                      const SizedBox.shrink(),
                ),
            ],
          ),
        ),
        // Scrollable columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: horizontalScrollController,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: scrollableWidth,
              child: Column(
                mainAxisSize: fitsInAvailableHeight
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: Row(
                      children: [
                        for (int i = 0; i < scrollableColumns.length; i++)
                          _ScrollableHeaderCellWrapper<T>(
                            col: scrollableColumns[i],
                            colWidth:
                                scrollableColumns[i].effectiveMinWidth +
                                extraPerColumn,
                            headerHeight: headerHeight,
                            headerBg: headerBg,
                            isSorted: sortColumnIndex == i + 1,
                            sortAscending: sortAscending,
                            onTap: () => onHeaderTap(i + 1),
                          ),
                      ],
                    ),
                  ),
                  () {
                    final list = ListView.builder(
                      controller: scrollableVerticalController,
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
                          columns: scrollableColumns,
                          rowHeight: rowHeight,
                          backgroundColor: rowBg,
                          extraPerColumn: extraPerColumn,
                          onTapRow: onTapRow,
                          showTapIndicator: false,
                        );
                      },
                    );

                    if (fitsInAvailableHeight) {
                      return SizedBox(
                        height: sortedItems.length * rowHeight,
                        child: list,
                      );
                    }
                    return Expanded(child: list);
                  }(),
                  if (hasFooter)
                    SizedBox(
                      height: footerHeight,
                      child: Row(
                        children: [
                          for (int i = 0; i < scrollableColumns.length; i++)
                            _ScrollableTableCell(
                              width:
                                  scrollableColumns[i].effectiveMinWidth +
                                  extraPerColumn,
                              height: footerHeight,
                              spec: scrollableColumns[i],
                              backgroundColor:
                                  footerBackgroundColor ?? headerBg,
                              showTopBorder: true,
                              child:
                                  scrollableColumns[i].footerCellBuilder?.call(
                                    sortedItems,
                                  ) ??
                                  const SizedBox.shrink(),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
