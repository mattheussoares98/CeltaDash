// lib/features/home/presentation/pages/products/components/products_table.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({
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
    final rows = statistics
        .map((statistic) {
          final parts = statistic.Product?.split('-');
          String productName = '';
          String? productCode;
          if (parts != null && parts.length > 2) {
            productCode = '${parts[0].trim()}-${parts[1].trim()}';
            productName = parts.sublist(2).join('-').trim();
          } else {
            productName = statistic.Product ?? '';
          }

          final sales = statistic.LiquidValue?.toDouble() ?? 0.0;
          final quantity = statistic.QuantityOfProducts?.toDouble() ?? 0.0;
          final cost = statistic.TotalRepositionCost?.toDouble() ?? 0.0;
          final averagePrice = quantity == 0 ? 0.0 : sales / quantity;
          final averageCost = quantity == 0 ? 0.0 : cost / quantity;
          final profit = sales - cost;
          final margin = (profit == 0 || sales == 0)
              ? 0.0
              : (profit / sales) * 100;

          return ProductsStatisticsRowState(
            productName: productName,
            productCode: productCode,
            sales: sales,
            quantity: quantity,
            averagePrice: averagePrice,
            cost: cost,
            averageCost: averageCost,
            profit: profit,
            margin: margin,
          );
        })
        .toList(growable: false);

    return ScrollableTable<ProductsStatisticsRowState>(
      items: rows,
      pdfFileName: 'Produtos'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 6,
      initialSortAscending: false,
      highlightColumnIndex: 6,
      rowHeight: Sizes.p64,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Produto'.hardcoded,
          minWidth: 150.0,
          cellBuilder: (row) => Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            children: [
              if (row.productCode?.isNotEmpty ?? false)
                BaseText.caption(row.productCode!, overflow: .ellipsis),
              BaseText(
                row.productName,
                maxLines: 2,
                overflow: .ellipsis,
                textAlign: .center,
              ),
            ],
          ),
          sortValueMapper: (row) => row.productName,
          textValueMapper: (row) =>
              row.productCode != null && row.productCode!.isNotEmpty
              ? '${row.productCode} - ${row.productName}'
              : row.productName,
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
          headerTitle: 'Preço médio'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.averagePrice.toString().toBRL()),
          sortValueMapper: (row) => row.averagePrice,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Custo'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.cost.toString().toBRL()),
          sortValueMapper: (row) => row.cost,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.cost)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.cost)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Custo médio'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.averageCost.toString().toBRL()),
          sortValueMapper: (row) => row.averageCost,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Lucro'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.profit.toString().toBRL()),
          sortValueMapper: (row) => row.profit,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.profit)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (items) => items
              .fold<double>(0, (total, row) => total + row.profit)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Margem'.hardcoded,
          minWidth: 80,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.margin.toString().toBRL()),
          sortValueMapper: (row) => row.margin,
        ),
      ],
    );
  }
}
