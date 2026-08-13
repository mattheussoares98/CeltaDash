part of 'scrollable_table.dart';

class ScrollableTableColumnSpec<T> {
  final String headerTitle;
  final double minWidth;
  final Widget Function(T item) cellBuilder;
  final Comparable Function(T item)? sortValueMapper;
  final Widget Function(List<T> items)? footerCellBuilder;
  final bool? isMoney;
  final bool? isPercentage;

  const ScrollableTableColumnSpec({
    required this.headerTitle,
    required this.minWidth,
    required this.cellBuilder,
    this.sortValueMapper,
    this.footerCellBuilder,
    this.isMoney,
    this.isPercentage,
  });
}
