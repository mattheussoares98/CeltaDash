// lib/features/home/presentation/pages/sales/components/tables/daily_sales_table.dart
part of '../sales_content.dart';

class _DailySalesTable extends StatelessWidget {
  const _DailySalesTable({
    required this.statistics,
    required this.selectedDate,
    this.isLoading = false,
  });

  final List<SaleStatisticsEntity> statistics;
  final DateTime selectedDate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final overallValue = statistics.fold<double>(
      0,
      (total, s) => total + (s.LiquidValue?.toDouble() ?? 0),
    );

    statistics.sort((a, b) => (a.Date?.day ?? 0).compareTo(b.Date?.day ?? 0));
    final grouped = groupBy(
      statistics,
      (SaleStatisticsEntity s) => s.Date?.day ?? 0,
    );
    final keys = grouped.keys.toList();

    final rows = keys.map((day) {
      final group = grouped[day]!;
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

      String? subtitle;
      if (day > 0) {
        final dayDate = DateTime(selectedDate.year, selectedDate.month, day);
        subtitle = DateFormat('EEE', 'pt_BR').format(dayDate).toUpperCase();
      }

      return SalesStatisticsRowState(
        description: day.toString().padLeft(2, '0'),
        subtitle: subtitle,
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
      initialSortColumnIndex: 0,
      initialSortAscending: false,
      highlightBestAndWorst: true,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Dia'.hardcoded,
          cellBuilder: (row) => row.subtitle != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseText.bodyMedium(row.description),
                    BaseText.caption(
                      row.subtitle!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : BaseText.bodyMedium(row.description),
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
