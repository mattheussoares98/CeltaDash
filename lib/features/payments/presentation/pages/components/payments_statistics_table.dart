import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/payments/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PaymentsStatisticsTable extends StatelessWidget {
  const PaymentsStatisticsTable({
    required this.saleStatistics,
    required this.filterByFinalizations,
    this.isLoading = false,
    super.key,
  });

  final List<SaleStatisticsEntity> saleStatistics;
  final bool filterByFinalizations;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final groupedStatistics = groupBy(saleStatistics, (
      SaleStatisticsEntity statistic,
    ) {
      final description = filterByFinalizations
          ? statistic.PaymentFinalization
          : statistic.PaymentModality;
      return description ?? 'Não informado'.hardcoded;
    });
    final overallValue = saleStatistics.fold<double>(
      0,
      (total, statistic) => total + (statistic.LiquidValue?.toDouble() ?? 0),
    );

    final rows = groupedStatistics.entries
        .map((entry) {
          final totalValue = entry.value.fold<double>(
            0,
            (total, statistic) =>
                total + (statistic.LiquidValue?.toDouble() ?? 0),
          );
          final totalQuantity = entry.value.fold<int>(
            0,
            (total, statistic) =>
                total + (statistic.QuantitySales?.toInt() ?? 0),
          );

          return PaymentsStatisticsRowState(
            description: entry.key,
            totalValue: totalValue,
            totalQuantity: totalQuantity,
            averageTicket: totalQuantity == 0
                ? 0.0
                : totalValue / totalQuantity,
            share: overallValue == 0 ? 0.0 : totalValue / overallValue * 100,
          );
        })
        .toList(growable: false);

    return ScrollableTable<PaymentsStatisticsRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      initialSortColumnIndex: 1,
      initialSortAscending: false,
      highlightBestAndWorst: true,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: R.string.paymentsType,
          minWidth: 100,
          cellBuilder: (row) => BaseText.bodyMedium(row.description),
          sortValueMapper: (row) => row.description,
        ),
        ScrollableTableColumnSpec(
          headerTitle: R.string.sales,
          minWidth: 90,
          isMoney: true,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.totalValue.toString().toBrazilianNumber(),
          ),
          sortValueMapper: (row) => row.totalValue,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.totalValue)
                .toString()
                .toBrazilianNumber(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: R.string.quantityAbbreviated,
          minWidth: 50,
          cellBuilder: (row) => BaseText.bodyMedium('${row.totalQuantity}'),
          sortValueMapper: (row) => row.totalQuantity,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            '${items.fold<int>(0, (total, row) => total + row.totalQuantity)}',
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: R.string.ticketAverage,
          minWidth: 70,
          isMoney: true,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.averageTicket.toString().toBrazilianNumber(),
          ),
          sortValueMapper: (row) => row.averageTicket,
        ),
        ScrollableTableColumnSpec(
          headerTitle: R.string.share,
          minWidth: 70,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.share.toString().toBrazilianNumber()),
          sortValueMapper: (row) => row.share,
        ),
      ],
    );
  }
}
