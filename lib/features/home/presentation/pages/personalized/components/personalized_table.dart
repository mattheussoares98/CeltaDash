// lib/features/home/presentation/pages/personalized/components/personalized_table.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PersonalizedTable extends HookConsumerWidget {
  const PersonalizedTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(
      personalizedControllerProvider.select((s) => s.sales),
    );
    final isGenerating = ref.watch(
      personalizedControllerProvider.select((s) => s.isGenerating),
    );

    return AsyncValueWidget<List<SaleStatisticsEntity>>(
      value: salesAsync,
      tryAgain: () =>
          ref.read(personalizedControllerProvider.notifier).generateReport(),
      data: (sales) {
        if (sales.isEmpty) {
          return const SizedBox.shrink();
        }

        final columnDefinitions =
            <
              String,
              ({
                bool Function(SaleStatisticsEntity) check,
                ScrollableTableColumnSpec<SaleStatisticsEntity> spec,
              })
            >{
              'Empresa'.hardcoded: (
                check: (s) => s.EnterpriseFantasyName != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Empresa'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.EnterpriseFantasyName ?? ''),
                  sortValueMapper: (s) => s.EnterpriseFantasyName ?? '',
                ),
              ),
              'Ano'.hardcoded: (
                check: (s) => s.Year != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Ano'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.Year?.toString() ?? ''),
                  sortValueMapper: (s) => s.Year ?? 0,
                ),
              ),
              'Mês'.hardcoded: (
                check: (s) => s.Month != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Mês'.hardcoded,
                  cellBuilder: (s) {
                    final date = DateTime(0, s.Month ?? 1);
                    return BaseText.bodyMedium(
                      date.formatDate(.MMM).toUpperCase().replaceAll('.', ''),
                    );
                  },
                  sortValueMapper: (s) => s.Month ?? 0,
                ),
              ),
              'Dia'.hardcoded: (
                check: (s) => s.Date != null && s.Hour == null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Dia'.hardcoded,
                  minWidth: 80,
                  cellBuilder: (s) => BaseText.bodyMedium(s.Date!.formatDate()),
                  sortValueMapper: (s) => s.Date ?? DateTime(0),
                ),
              ),
              'Hora'.hardcoded: (
                check: (s) => s.Hour != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Hora'.hardcoded,
                  cellBuilder: (s) {
                    final formatter = DateFormat('yyyy/MM/dd', 'pt_BR');
                    final dateStr = s.Date != null
                        ? formatter.format(s.Date!)
                        : '';
                    return BaseText.bodySmall('${s.Hour}h\n$dateStr');
                  },
                  sortValueMapper: (s) => s.Hour ?? 0,
                ),
              ),
              'Produto'.hardcoded: (
                check: (s) => s.Product != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Produto'.hardcoded,
                  cellBuilder: (s) {
                    final parts = s.Product?.split('-');
                    final name = (parts != null && parts.length > 2)
                        ? parts[2]
                        : (s.Product ?? '');
                    return BaseText.bodyMedium(name, maxLines: 2);
                  },
                  sortValueMapper: (s) => s.Product ?? '',
                ),
              ),
              'Qtd produtos'.hardcoded: (
                check: (s) => s.QuantityOfProducts != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Qtd produtos'.hardcoded,
                  cellBuilder: (s) => BaseText.bodyMedium(
                    s.QuantityOfProducts?.toString().toBRL(3, true) ?? '',
                  ),
                  sortValueMapper: (s) => s.QuantityOfProducts ?? 0,
                  footerCellBuilder: (items) => BaseText.bodyMedium(
                    items
                        .fold<num>(
                          0,
                          (total, s) => total + (s.QuantityOfProducts ?? 0),
                        )
                        .toString()
                        .toBRL(3, true),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              'Departamento'.hardcoded: (
                check: (s) => s.ProductDepartment != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Departamento'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.ProductDepartment ?? ''),
                  sortValueMapper: (s) => s.ProductDepartment ?? '',
                ),
              ),
              'Seção'.hardcoded: (
                check: (s) => s.ProductSection != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Seção'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.ProductSection ?? ''),
                  sortValueMapper: (s) => s.ProductSection ?? '',
                ),
              ),
              'Finalizadora'.hardcoded: (
                check: (s) => s.PaymentFinalization != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Finalizadora'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.PaymentFinalization ?? ''),
                  sortValueMapper: (s) => s.PaymentFinalization ?? '',
                ),
              ),
              'Modalidade'.hardcoded: (
                check: (s) => s.PaymentModality != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Modalidade'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.PaymentModality ?? ''),
                  sortValueMapper: (s) => s.PaymentModality ?? '',
                ),
              ),
              'Qtd vendas'.hardcoded: (
                check: (s) => s.QuantitySales != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Qtd vendas'.hardcoded,
                  cellBuilder: (s) => BaseText.bodyMedium(
                    s.QuantitySales?.toString().toBRL(2, true) ?? '',
                  ),
                  sortValueMapper: (s) => s.QuantitySales ?? 0,
                  footerCellBuilder: (items) => BaseText.bodyMedium(
                    items
                        .fold<int>(
                          0,
                          (total, s) => total + (s.QuantitySales ?? 0),
                        )
                        .toString()
                        .toBRL(2, true),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              'Operador'.hardcoded: (
                check: (s) => s.CashierOperator != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Operador'.hardcoded,
                  cellBuilder: (s) =>
                      BaseText.bodyMedium(s.CashierOperator ?? ''),
                  sortValueMapper: (s) => s.CashierOperator ?? '',
                ),
              ),
              'Vendedor'.hardcoded: (
                check: (s) => s.Seller != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Vendedor'.hardcoded,
                  cellBuilder: (s) => BaseText.bodyMedium(s.Seller ?? ''),
                  sortValueMapper: (s) => s.Seller ?? '',
                ),
              ),
              'Total'.hardcoded: (
                check: (s) => s.LiquidValue != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Total'.hardcoded,
                  isMoney: true,
                  cellBuilder: (s) => BaseText.bodyMedium(
                    (s.LiquidValue?.toDouble() ?? 0).toString().toBRL(),
                  ),
                  sortValueMapper: (s) => s.LiquidValue ?? 0,
                  footerCellBuilder: (items) => BaseText.bodyMedium(
                    items
                        .fold<double>(
                          0,
                          (total, s) =>
                              total + (s.LiquidValue?.toDouble() ?? 0),
                        )
                        .toString()
                        .toBRL(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              'Custo'.hardcoded: (
                check: (s) => s.TotalRepositionCost != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Custo'.hardcoded,
                  isMoney: true,
                  cellBuilder: (s) => BaseText.bodyMedium(
                    (s.TotalRepositionCost?.toDouble() ?? 0).toString().toBRL(),
                  ),
                  sortValueMapper: (s) => s.TotalRepositionCost ?? 0,
                  footerCellBuilder: (items) => BaseText.bodyMedium(
                    items
                        .fold<double>(
                          0,
                          (total, s) =>
                              total + (s.TotalRepositionCost?.toDouble() ?? 0),
                        )
                        .toString()
                        .toBRL(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              'Lucro'.hardcoded: (
                check: (s) =>
                    s.LiquidValue != null && s.TotalRepositionCost != null,
                spec: ScrollableTableColumnSpec<SaleStatisticsEntity>(
                  headerTitle: 'Lucro'.hardcoded,
                  isMoney: true,
                  cellBuilder: (s) {
                    final profit =
                        (s.LiquidValue?.toDouble() ?? 0) -
                        (s.TotalRepositionCost?.toDouble() ?? 0);
                    return BaseText.bodyMedium(profit.toString().toBRL());
                  },
                  sortValueMapper: (s) =>
                      (s.LiquidValue?.toDouble() ?? 0) -
                      (s.TotalRepositionCost?.toDouble() ?? 0),
                  footerCellBuilder: (items) {
                    final totalProfit = items.fold<double>(
                      0,
                      (total, s) =>
                          total +
                          ((s.LiquidValue?.toDouble() ?? 0) -
                              (s.TotalRepositionCost?.toDouble() ?? 0)),
                    );
                    return BaseText.bodyMedium(
                      totalProfit.toString().toBRL(),
                      fontWeight: FontWeight.bold,
                    );
                  },
                ),
              ),
            };

        final remainingChecks = columnDefinitions.keys.toSet();
        final populatedTitles = <String>{};
        for (final sale in sales) {
          if (remainingChecks.isEmpty) break;
          final foundInThisPass = <String>{};
          for (final title in remainingChecks) {
            if (columnDefinitions[title]!.check(sale)) {
              populatedTitles.add(title);
              foundInThisPass.add(title);
            }
          }
          remainingChecks.removeAll(foundInThisPass);
        }

        final activeColumns = columnDefinitions.entries
            .where((entry) => populatedTitles.contains(entry.key))
            .map((entry) => entry.value.spec)
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxHeight < 120.0) {
              return const SizedBox.shrink();
            }

            return ScrollableTable<SaleStatisticsEntity>(
              items: sales,
              columns: activeColumns,
              fixFirstColumn: true,
              isLoading: isGenerating,
            );
          },
        );
      },
    );
  }
}
