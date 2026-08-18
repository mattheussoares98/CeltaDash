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
  final void Function(ScrollController, bool) onScrollNotification;
  final bool Function(ScrollController) shouldConsumeScrollNotification;
  final bool hasFooter;
  final ScrollPhysics? fixedPhysics;
  final ScrollPhysics? scrollablePhysics;
  final void Function(T item)? onTapRow;
  final Color? Function(T item)? rowColor;
  final bool fitsInAvailableHeight;

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
    required this.onScrollNotification,
    required this.shouldConsumeScrollNotification,
    required this.hasFooter,
    required this.fixedPhysics,
    required this.scrollablePhysics,
    required this.onTapRow,
    required this.rowColor,
    required this.fitsInAvailableHeight,
    this.horizontalScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final firstCol = columns.first;
    final double firstColWidth = firstCol.minWidth + extraPerColumn;
    final theme = context.theme;
    final Color headerBg =
        headerBackgroundColor ?? theme.disabledColor.withAlpha(30);
    final double scrollableWidth = scrollableColumns.fold(
      0.0,
      (sum, col) => sum + col.minWidth + extraPerColumn,
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
                ),
              ),
              () {
                final list = ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        onScrollNotification(fixedVerticalController, true);
                      } else if (notification is ScrollEndNotification) {
                        onScrollNotification(fixedVerticalController, false);
                      }

                      // Stop scroll events from the jumped list bubbling to the RefreshIndicator
                      if (shouldConsumeScrollNotification(
                        fixedVerticalController,
                      )) {
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: fixedVerticalController,
                      physics: fixedPhysics,
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
                        final cell = _ScrollableTableCell(
                          width: firstColWidth,
                          height: rowHeight,
                          spec: firstCol,
                          backgroundColor: rowBg,
                          child: firstCol.cellBuilder(item),
                        );
                        if (onTapRow != null) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onTapRow!(sortedItems[index]),
                            child: cell,
                          );
                        }
                        return cell;
                      },
                    ),
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
                                scrollableColumns[i].minWidth + extraPerColumn,
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
                    final list = NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification) {
                          onScrollNotification(
                            scrollableVerticalController,
                            true,
                          );
                        } else if (notification is ScrollEndNotification) {
                          onScrollNotification(
                            scrollableVerticalController,
                            false,
                          );
                        }

                        // Stop scroll events from the jumped list bubbling to the RefreshIndicator
                        if (shouldConsumeScrollNotification(
                          scrollableVerticalController,
                        )) {
                          return true;
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: scrollableVerticalController,
                        physics: scrollablePhysics,
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
                          );
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
                    SizedBox(
                      height: footerHeight,
                      child: Row(
                        children: [
                          for (int i = 0; i < scrollableColumns.length; i++)
                            _ScrollableTableCell(
                              width:
                                  scrollableColumns[i].minWidth +
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
