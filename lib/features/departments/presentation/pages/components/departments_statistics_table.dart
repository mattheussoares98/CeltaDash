// lib/features/departments/presentation/pages/components/departments_statistics_table.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/departments/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DepartmentsStatisticsTable extends StatelessWidget {
  const DepartmentsStatisticsTable({
    required this.saleStatistics,
    this.isLoading = false,
    super.key,
  });

  final List<SaleStatisticsEntity> saleStatistics;
  final bool isLoading;

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
      fixFirstColumn: true,
      isLoading: isLoading,
      initialSortColumnIndex: 3,
      initialSortAscending: false,
      highlightBestAndWorst: true,
      rowHeight: Sizes.p64,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Dep.'.hardcoded,
          cellBuilder: (row) => BaseText(row.department, maxLines: 2),
          sortValueMapper: (row) => row.department,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Vendas'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.sales.toString().toBrazilianNumber()),
          sortValueMapper: (row) => row.sales,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.sales)
                .toString()
                .toBrazilianNumber(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Custo'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.cost.toString().toBrazilianNumber()),
          sortValueMapper: (row) => row.cost,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.cost)
                .toString()
                .toBrazilianNumber(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Lucro'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.profit.toString().toBrazilianNumber()),
          sortValueMapper: (row) => row.profit,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(0, (total, row) => total + row.profit)
                .toString()
                .toBrazilianNumber(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Margem'.hardcoded,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.margin.toString().toBrazilianNumber()),
          sortValueMapper: (row) => row.margin,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Share'.hardcoded,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.share.toString().toBrazilianNumber()),
          sortValueMapper: (row) => row.share,
        ),
      ],
    );
  }
}
