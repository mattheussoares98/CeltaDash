part of 'scrollable_table.dart';

class ScrollableTableColumnSpec<T> {
  final String headerTitle;
  final double? minWidth;
  final Widget Function(T item) cellBuilder;
  final Comparable Function(T item)? sortValueMapper;
  final Widget Function(List<T> items)? footerCellBuilder;
  final bool? isMoney;
  final bool? isPercentage;

  const ScrollableTableColumnSpec({
    required this.headerTitle,
    this.minWidth,
    required this.cellBuilder,
    this.sortValueMapper,
    this.footerCellBuilder,
    this.isMoney,
    this.isPercentage,
  });

  double get effectiveMinWidth {
    if (minWidth != null) return minWidth!;

    if (isMoney == true) {
      // Single-word money column ("Vendas") needs room for large totals (~115px)
      // Multi-word money column ("Ticket médio") is more compact (~85px)
      return headerTitle.contains(' ') ? 85.0 : 115.0;
    }
    if (isPercentage == true) {
      return 60.0;
    }

    final words = headerTitle.split(' ');
    int maxWordLength = 0;
    for (final word in words) {
      if (word.length > maxWordLength) {
        maxWordLength = word.length;
      }
    }

    if (words.length > 1) {
      // Multi-word descriptions ("Forma de pagamento")
      final estimatedWidth = (maxWordLength * 9.0) + 50.0;
      return math.max(125.0, estimatedWidth);
    }

    // Single-word columns ("Qtd")
    final estimatedWidth = (maxWordLength * 9.0) + 38.0;
    return math.max(65.0, estimatedWidth);
  }
}
