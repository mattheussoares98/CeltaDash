// lib/features/group_summary/presentation/pages/components/group_summary_details_table.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/group_summary/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class GroupSummaryDetailsTable extends StatelessWidget {
  const GroupSummaryDetailsTable({
    required this.saleStatistics,
    this.isLoading = false,
    super.key,
  });

  final List<SaleStatisticsEntity> saleStatistics;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final overallValue = saleStatistics.fold<double>(
      0,
      (total, statistic) => total + (statistic.LiquidValue?.toDouble() ?? 0),
    );

    final groupedStatistics = groupBy(saleStatistics, (
      SaleStatisticsEntity statistic,
    ) {
      return statistic.EnterpriseId;
    });

    final rows = groupedStatistics.entries
        .map((entry) {
          final first = entry.value.first;
          final code = first.EnterprisePersonalizedCode?.trim();
          final fantasyName = first.EnterpriseFantasyName?.trim();
          final nameParts = [
            if (code?.isNotEmpty ?? false) code!,
            if (fantasyName?.isNotEmpty ?? false) fantasyName!,
          ];
          final enterpriseName = nameParts.isEmpty
              ? 'Não informado'.hardcoded
              : nameParts.join(' - ');

          final totalSales = entry.value.fold<double>(
            0,
            (total, statistic) =>
                total + (statistic.LiquidValue?.toDouble() ?? 0),
          );
          final share = overallValue == 0
              ? 0.0
              : (totalSales / overallValue) * 100;

          return GroupSummaryEnterpriseRowState(
            enterpriseId: entry.key,
            enterpriseName: enterpriseName,
            sales: totalSales,
            share: share,
          );
        })
        .toList(growable: false);

    return ScrollableTable<GroupSummaryEnterpriseRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      initialSortColumnIndex: 1,
      initialSortAscending: false,
      highlightColumnIndex: 1,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Empresa'.hardcoded,
          cellBuilder: (row) => BaseText(row.enterpriseName, maxLines: 2),
          sortValueMapper: (row) => row.enterpriseName,
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
