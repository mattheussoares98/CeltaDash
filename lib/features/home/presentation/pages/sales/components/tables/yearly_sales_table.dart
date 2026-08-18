// lib/features/home/presentation/pages/sales/components/tables/yearly_sales_table.dart
part of '../sales_content.dart';

class _YearlySalesTable extends StatelessWidget {
  const _YearlySalesTable({
    required this.statistics,
    required this.refreshProvider,
    this.isLoading = false,
  });

  final List<SaleStatisticsEntity> statistics;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final overallValue = statistics.fold<double>(
      0,
      (total, s) => total + (s.LiquidValue?.toDouble() ?? 0),
    );

    final grouped = groupBy(
      statistics,
      (SaleStatisticsEntity s) => s.Year ?? 0,
    );
    final sortedKeys = grouped.keys.toList()..sort();

    final rows = sortedKeys.map((year) {
      final group = grouped[year]!;
      final sales = group.fold<double>(
        0,
        (total, s) => total + (s.LiquidValue?.toDouble() ?? 0),
      );
      final quantity = group.fold<double>(
        0,
        (total, s) => total + (s.QuantitySales?.toDouble() ?? 0),
      );
      final averageTicket = quantity == 0 ? 0.0 : sales / quantity;
      final share = overallValue == 0 ? 0.0 : (sales / overallValue) * 100;

      return SalesStatisticsRowState(
        description: year.toString(),
        sales: sales,
        quantity: quantity,
        averageTicket: averageTicket,
        share: share,
      );
    }).toList();

    return ScrollableTable<SalesStatisticsRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 0,
      highlightColumnIndex: 1,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Ano'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(row.description),
          sortValueMapper: (row) => row.description,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Vendas'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.sales.toString().toBRL()),
          sortValueMapper: (row) => row.sales,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.sales)
                .toString()
                .toBRL(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Qtd'.hardcoded,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.quantity.toString().toBRL(0, true)),
          sortValueMapper: (row) => row.quantity,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.quantity)
                .toString()
                .toBRL(0, true),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Ticket médio'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.averageTicket.toString().toBRL()),
          sortValueMapper: (row) => row.averageTicket,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Share'.hardcoded,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.share.toString().toBRL()),
          sortValueMapper: (row) => row.share,
        ),
      ],
    );
  }
}
