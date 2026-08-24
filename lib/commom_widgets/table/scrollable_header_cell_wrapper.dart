part of 'scrollable_table.dart';

class _ScrollableHeaderCellWrapper<T> extends StatelessWidget {
  final ScrollableTableColumnSpec<T> col;
  final double colWidth;
  final double headerHeight;
  final Color headerBg;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback onTap;
  final VoidCallback? onPdfTap;

  const _ScrollableHeaderCellWrapper({
    required this.col,
    required this.colWidth,
    required this.headerHeight,
    required this.headerBg,
    required this.isSorted,
    required this.sortAscending,
    required this.onTap,
    this.onPdfTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ScrollableTableCell(
      width: colWidth,
      height: headerHeight,
      spec: col,
      backgroundColor: headerBg,
      showBottomBorder: true,
      child: _ScrollableTableHeaderCell<T>(
        spec: col,
        isSorted: isSorted,
        sortAscending: sortAscending,
        onTap: onTap,
        onPdfTap: onPdfTap,
      ),
    );
  }
}
