// lib/features/departments/presentation/pages/components/departments_statistics_table.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/departments/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/departments/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DepartmentsStatisticsTable extends StatelessWidget {
  const DepartmentsStatisticsTable({
    required this.saleStatistics,
    this.isLoading = false,
    required this.provider,
    super.key,
  });

  final List<SaleStatisticsEntity> saleStatistics;
  final bool isLoading;
  final DepartmentsControllerProvider provider;

  @override
  Widget build(BuildContext context) {
    final groupedStatistics = groupBy(saleStatistics, (
      SaleStatisticsEntity statistic,
    ) {
      return statistic.ProductDepartment ?? 'Não informado'.hardcoded;
    });

    final overallValue = saleStatistics.fold<double>(
      0,
      (total, statistic) => total + (statistic.LiquidValue?.toDouble() ?? 0),
    );

    final rows = groupedStatistics.entries
        .map((entry) {
          final totalSales = entry.value.fold<double>(
            0,
            (total, statistic) =>
                total + (statistic.LiquidValue?.toDouble() ?? 0),
          );
          final totalCost = entry.value.fold<double>(
            0,
            (total, statistic) =>
                total + (statistic.TotalRepositionCost?.toDouble() ?? 0),
          );
          final profit = totalSales - totalCost;
          final margin = (profit == 0 || totalSales == 0)
              ? 0.0
              : (profit / totalSales) * 100;
          final share = overallValue == 0
              ? 0.0
              : (totalSales / overallValue) * 100;

          return DepartmentsStatisticsRowState(
            department: entry.key,
            sales: totalSales,
            cost: totalCost,
            profit: profit,
            margin: margin,
            share: share,
          );
        })
        .toList(growable: false);

    return ScrollableTable<DepartmentsStatisticsRowState>(
      items: rows,
      pdfFileName: 'Departamentos'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      initialSortColumnIndex: 3,
      initialSortAscending: false,
      highlightColumnIndex: 3,
      rowHeight: Sizes.p64,
      refreshProvider: provider,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Dep.'.hardcoded,
          cellBuilder: (row) => BaseText(row.department, maxLines: 2),
          sortValueMapper: (row) => row.department,
          textValueMapper: (row) => row.department,
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
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.margin.toString().toBRL()),
          sortValueMapper: (row) => row.margin,
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
