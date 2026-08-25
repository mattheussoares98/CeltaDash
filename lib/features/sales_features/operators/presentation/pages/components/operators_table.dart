import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/operators/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class OperatorsTable extends StatelessWidget {
  const OperatorsTable({
    required this.statistics,
    required this.refreshProvider,
    this.isLoading = false,
    super.key,
  });

  final List<SaleStatisticsEntity> statistics;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final rowsByOperator = <String, OperatorsStatisticsRowState>{};
    for (final statistic in statistics) {
      final operatorName = statistic.CashierOperator?.trim();
      final normalizedName = operatorName == null || operatorName.isEmpty
          ? 'Desconhecido'.hardcoded
          : operatorName;
      final sales = statistic.LiquidValue?.toDouble() ?? 0;
      final quantity = statistic.QuantitySales ?? 0;
      final current = rowsByOperator[normalizedName];
      rowsByOperator[normalizedName] = current == null
          ? OperatorsStatisticsRowState(
              operatorName: normalizedName,
              sales: sales,
              quantity: quantity,
            )
          : current.add(sales: sales, quantity: quantity);
    }
    final rows = rowsByOperator.values.toList(growable: false);

    return ScrollableTable<OperatorsStatisticsRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 1,
      initialSortAscending: false,
      highlightColumnIndex: 1,
      pdfFileName: 'Operadores'.hardcoded,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Operador'.hardcoded,
          minWidth: 150,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.operatorName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          sortValueMapper: (row) => row.operatorName,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Total'.hardcoded,
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
          headerTitle: 'Qtd vendas'.hardcoded,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.quantity.toString().toBRL(0)),
          sortValueMapper: (row) => row.quantity,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<int>(0, (total, row) => total + row.quantity)
                .toString()
                .toBRL(0),
          ),
          footerTextValueMapper: (items) => items
              .fold<int>(0, (total, row) => total + row.quantity)
              .toString()
              .toBRL(0),
        ),
      ],
    );
  }
}
