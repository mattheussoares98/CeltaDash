// lib/features/home/presentation/pages/sales/components/tables/hourly_sales_table.dart
part of '../sales_content.dart';

class _HourlySalesTable extends ConsumerWidget {
  const _HourlySalesTable({
    required this.statistics,
    required this.refreshProvider,
    this.isLoading = false,
  });

  final List<SaleStatisticsEntity> statistics;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallValue = statistics.fold<double>(
      0,
      (total, s) => total + (s.LiquidValue?.toDouble() ?? 0),
    );

    statistics.sort((a, b) => a.Hour!.compareTo(b.Hour!));
    final grouped = groupBy(
      statistics,
      (SaleStatisticsEntity s) => s.Hour ?? 0,
    );
    final keys = grouped.keys.toList();

    final rows = keys.map((hour) {
      final group = grouped[hour]!;
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
        description: '$hour:00 ~ $hour:59',
        sales: sales,
        quantity: quantity,
        averageTicket: averageTicket,
        share: share,
      );
    }).toList();

    return ScrollableTable<SalesStatisticsRowState>(
      items: rows,
      pdfFileName: 'Vendas por hora'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      highlightColumnIndex: 1,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Hora'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(row.description),
          sortValueMapper: (row) => row.description,
          textValueMapper: (row) => ref.read(
            homeControllerProvider.select(
              (s) =>
                  '${s.value?.selectedDate.formatDate() ?? ''} ${row.description}',
            ),
          ),
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
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.sales)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Qtd'.hardcoded,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.quantity.toString().toBRL(0, true)),
          sortValueMapper: (row) => row.quantity,
          textValueMapper: (row) => row.quantity.toString().toBRL(0, true),
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.quantity)
                .toString()
                .toBRL(0, true),
          ),
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.quantity)
              .toString()
              .toBRL(0, true),
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
