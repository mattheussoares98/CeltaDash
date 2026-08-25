// lib/features/group_summary/presentation/pages/components/group_summary_resume_tab.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/group_summary/presentation/pages/components/group_summary_indicator_card.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSummaryResumeTab extends StatelessWidget {
  const GroupSummaryResumeTab({required this.saleStatistics, super.key});

  final List<SaleStatisticsEntity> saleStatistics;

  @override
  Widget build(BuildContext context) {
    final uniqueEnterprises = saleStatistics
        .map((s) => s.EnterpriseId)
        .whereType<int>()
        .toSet();
    final enterprisesCount = uniqueEnterprises.isEmpty
        ? 1
        : uniqueEnterprises.length;

    final totalSales = saleStatistics.fold<double>(
      0,
      (total, s) => total + (s.LiquidValue?.toDouble() ?? 0),
    );
    final averageSales = totalSales / enterprisesCount;

    final totalQuantity = saleStatistics.fold<int>(
      0,
      (total, s) => total + (s.QuantitySales?.toInt() ?? 0),
    );
    final averageQuantity = totalQuantity / enterprisesCount;

    final enterpriseLabel = enterprisesCount == 1
        ? 'empresa'.hardcoded
        : 'empresas'.hardcoded;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GroupSummaryIndicatorCard(
            firstTitle:
                'Total de vendas do grupo ($enterprisesCount $enterpriseLabel)'
                    .hardcoded,
            firstValue: 'R\$ ${totalSales.toString().toBRL()}',
            secondTitle: 'Média de vendas do grupo'.hardcoded,
            secondValue: 'R\$ ${averageSales.toString().toBRL()}',
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.money_dollar_circle_fill,
              materialIcon: Icons.monetization_on,
            ),
          ),
          gapH8,
          GroupSummaryIndicatorCard(
            firstTitle: 'Qtd. de vendas'.hardcoded,
            firstValue: totalQuantity.toString().toBRL(0),
            secondTitle: 'Média de quantidade de vendas'.hardcoded,
            secondValue: averageQuantity.toString().toBRL(2, true),
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.doc_text,
              materialIcon: Icons.receipt_long,
            ),
          ),
        ],
      ),
    );
  }
}
