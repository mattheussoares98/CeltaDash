// lib/features/home/presentation/pages/financial/components/tables/yearly_financial_table.dart
part of '../financial_periods_content.dart';

class _YearlyFinancialTable extends StatelessWidget {
  const _YearlyFinancialTable({
    required this.portions,
    required this.refreshProvider,
    this.isLoading = false,
  });

  final List<FinancialTitleDataRowEntity> portions;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final sorted = List<FinancialTitleDataRowEntity>.from(portions)
      ..sort((a, b) => (a.year ?? 0).compareTo(b.year ?? 0));

    final grouped = groupBy(
      sorted,
      (FinancialTitleDataRowEntity p) => p.year ?? 0,
    );
    final keys = grouped.keys.toList();

    final rows = keys.map((year) {
      final group = grouped[year]!;
      final receive = group.fold<double>(
        0,
        (total, p) => total + (p.receiveLiquidValue?.toDouble() ?? 0),
      );
      final pay = group.fold<double>(
        0,
        (total, p) => total + (p.payLiquidValue?.toDouble() ?? 0),
      );
      final balance = receive - pay;

      return FinancialStatisticsRowState(
        description: year.toString(),
        receive: receive,
        pay: pay,
        balance: balance,
      );
    }).toList();

    return ScrollableTable<FinancialStatisticsRowState>(
      items: rows,
      pdfFileName: 'Movimentação financeira por ano'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 0,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Ano'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(row.description),
          sortValueMapper: (row) => row.description,
          textValueMapper: (row) => row.description,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Receber'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.receive.toString().toBRL()),
          sortValueMapper: (row) => row.receive,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.receive)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.receive)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Pagar'.hardcoded,
          isMoney: true,
          cellBuilder: (row) => BaseText.bodyMedium(row.pay.toString().toBRL()),
          sortValueMapper: (row) => row.pay,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.pay)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.pay)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Saldo'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.balance.toString().toBRL()),
          sortValueMapper: (row) => row.balance,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.balance)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.balance)
              .toString()
              .toBRL(),
        ),
      ],
    );
  }
}
