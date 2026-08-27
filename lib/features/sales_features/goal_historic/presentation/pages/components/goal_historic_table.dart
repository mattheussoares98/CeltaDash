import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/goal_historic/presentation/presentation.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoalHistoricTable extends ConsumerWidget {
  const GoalHistoricTable({super.key, required this.enterpriseId});
  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = goalHistoricControllerProvider(enterpriseId);
    final stateAsync = ref.watch(provider);

    return AsyncValueWidget(
      value: stateAsync,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (state) {
        if (state.rows.isEmpty) {
          return Center(
            child: BaseText(
              'Nenhuma meta ou venda encontrada para este ano'.hardcoded,
            ),
          );
        }

        return ScrollableTable<GoalHistoricRowState>(
          items: state.rows,
          fixFirstColumn: true,
          isLoading: stateAsync.isLoading,
          highlightColumnIndex: 3,
          refreshProvider: provider,
          columns: [
            ScrollableTableColumnSpec(
              headerTitle: 'Mês'.hardcoded,
              minWidth: 90,
              cellBuilder: (row) => BaseText.bodyMedium(
                DateTime(row.year, row.month).formatDate(.MMMM).toUpperCase(),
              ),
              sortValueMapper: (row) => row.year * 100 + row.month,
            ),
            ScrollableTableColumnSpec(
              headerTitle: 'Meta'.hardcoded,
              isMoney: true,
              cellBuilder: (row) =>
                  BaseText.bodyMedium(row.goalValue.toString().toBRL()),
              sortValueMapper: (row) => row.goalValue,
              footerCellBuilder: (rows) => BaseText.bodyMedium(
                rows
                    .fold<double>(0.0, (acc, row) => acc + row.goalValue)
                    .toString()
                    .toBRL(),
              ),
            ),
            ScrollableTableColumnSpec(
              headerTitle: 'Vendas'.hardcoded,
              isMoney: true,
              cellBuilder: (row) =>
                  BaseText.bodyMedium(row.salesValue.toString().toBRL()),
              sortValueMapper: (row) => row.salesValue,
              footerCellBuilder: (rows) => BaseText.bodyMedium(
                rows
                    .fold<double>(0.0, (acc, row) => acc + row.salesValue)
                    .toString()
                    .toBRL(),
              ),
            ),
            ScrollableTableColumnSpec(
              headerTitle: 'Resultado'.hardcoded,
              isPercentage: true,
              minWidth: 90,
              cellBuilder: (row) {
                final isReached = row.isGoalReached;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                    vertical: Sizes.p4,
                  ),
                  decoration: BoxDecoration(
                    color: isReached
                        ? Colors.green.withAlpha(50)
                        : Colors.red.withAlpha(50),
                    borderRadius: BorderRadius.circular(Sizes.p4),
                  ),
                  child: BaseText.bodyMedium(
                    '${row.percentageValue.toString().toBRL()}%',
                  ),
                );
              },
              sortValueMapper: (row) => row.percentageValue,
            ),
          ],
        );
      },
    );
  }
}
