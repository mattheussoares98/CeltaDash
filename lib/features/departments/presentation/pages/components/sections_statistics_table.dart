// lib/features/departments/presentation/pages/components/sections_statistics_table.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/departments/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SectionsStatisticsTable extends StatelessWidget {
  const SectionsStatisticsTable({
    required this.saleStatistics,
    this.isLoading = false,
    super.key,
  });

  final List<SaleStatisticsEntity> saleStatistics;
  final bool isLoading;

  static Color _generateDepartmentColor(String department) {
    final hash = department.hashCode.abs();
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(0.20, hue, 0.65, 0.50).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final departmentColorMap = <String, Color>{};

    final groupedStatistics = groupBy(saleStatistics, (
      SaleStatisticsEntity statistic,
    ) {
      final dept = statistic.ProductDepartment ?? '';
      final sect = statistic.ProductSection ?? '';
      return '$dept|$sect';
    });

    final overallValue = saleStatistics.fold<double>(
      0,
      (total, statistic) => total + (statistic.LiquidValue?.toDouble() ?? 0),
    );

    final rows = groupedStatistics.entries
        .map((entry) {
          final first = entry.value.first;
          final dept = first.ProductDepartment ?? 'Não informado'.hardcoded;
          final sect = first.ProductSection ?? 'Não informado'.hardcoded;

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

          final departmentColor = departmentColorMap.putIfAbsent(
            dept,
            () => _generateDepartmentColor(dept),
          );

          return SectionsStatisticsRowState(
            department: dept,
            section: sect,
            sales: totalSales,
            cost: totalCost,
            profit: profit,
            margin: margin,
            share: share,
            departmentColor: departmentColor,
          );
        })
        .toList(growable: false);

    return ScrollableTable<SectionsStatisticsRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      initialSortColumnIndex: 3,
      initialSortAscending: false,
      highlightBestAndWorst: true,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Seções'.hardcoded,
          cellBuilder: (row) => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: row.departmentColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseText.bodySmall(
                  row.department,
                  maxLines: 1,
                  fontWeight: FontWeight.w600,
                ),
                BaseText.caption(row.section, maxLines: 2, textAlign: .center),
              ],
            ),
          ),
          sortValueMapper: (row) => '${row.department}_${row.section}',
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
