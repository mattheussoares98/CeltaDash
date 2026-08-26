// lib/features/home/presentation/pages/financial/components/tables/daily_financial_table.dart
part of '../financial_periods_content.dart';

class _DailyFinancialTable extends StatelessWidget {
  const _DailyFinancialTable({
    required this.portions,
    required this.selectedDate,
    required this.refreshProvider,
    this.isLoading = false,
  });

  final List<FinancialTitleDataRowEntity> portions;
  final DateTime selectedDate;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final sorted = List<FinancialTitleDataRowEntity>.from(portions)
      ..sort((a, b) => (a.date?.day ?? 0).compareTo(b.date?.day ?? 0));

    final grouped = groupBy(
      sorted,
      (FinancialTitleDataRowEntity p) => p.date?.day ?? 0,
    );
    final keys = grouped.keys.toList();

    final rows = keys.map((day) {
      final group = grouped[day]!;
      final receive = group.fold<double>(
        0,
        (total, p) => total + (p.receiveLiquidValue?.toDouble() ?? 0),
      );
      final pay = group.fold<double>(
        0,
        (total, p) => total + (p.payLiquidValue?.toDouble() ?? 0),
      );
      final balance = receive - pay;

      String? subtitle;
      if (day > 0) {
        final dayDate = DateTime(selectedDate.year, selectedDate.month, day);
        subtitle = DateFormat('EEE', 'pt_BR').format(dayDate).toUpperCase();
      }

      return FinancialStatisticsRowState(
        description: day.toString().padLeft(2, '0'),
        subtitle: subtitle,
        receive: receive,
        pay: pay,
        balance: balance,
      );
    }).toList();

    return ScrollableTable<FinancialStatisticsRowState>(
      items: rows,
      pdfFileName: 'Movimentação financeira por dia'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      highlightColumnIndex: 3,
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
          textValueMapper: (row) => row.subtitle != null
              ? '${row.description} (${row.subtitle})'
              : row.description,
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
