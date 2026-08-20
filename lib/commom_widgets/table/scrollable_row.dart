part of 'scrollable_table.dart';

class _ScrollableRow<T> extends StatelessWidget {
  final T item;
  final List<ScrollableTableColumnSpec<T>> columns;
  final double rowHeight;
  final Color? backgroundColor;
  final double extraPerColumn;
  final void Function(T item)? onTapRow;
  final bool showTapIndicator;

  const _ScrollableRow({
    required this.item,
    required this.columns,
    required this.rowHeight,
    required this.backgroundColor,
    required this.extraPerColumn,
    required this.onTapRow,
    required this.showTapIndicator,
  });

  @override
  Widget build(BuildContext context) {
    Widget row = SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          for (final col in columns)
            _ScrollableTableCell(
              width: col.effectiveMinWidth + extraPerColumn,
              height: rowHeight,
              spec: col,
              backgroundColor: backgroundColor,
              child: col.cellBuilder(item),
            ),
        ],
      ),
    );

    if (onTapRow != null) {
      if (showTapIndicator) {
        row = _TappableRowIndicator(child: row);
      }
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTapRow!(item),
        child: row,
      );
    }
    return row;
  }
}
