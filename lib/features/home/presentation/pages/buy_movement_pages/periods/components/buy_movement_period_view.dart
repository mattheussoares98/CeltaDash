import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuyMovementPeriodView extends ConsumerWidget {
  const BuyMovementPeriodView({
    required this.enterpriseId,
    required this.period,
    super.key,
  });

  final int enterpriseId;
  final HomeBuyMovementPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeBuyMovementControllerProvider(enterpriseId, period);
    final value = ref.watch(provider);
    return AsyncValueWidget(
      value: value,
      preserveValue: true,
      tryAgain: () => ref.invalidate(provider),
      data: (state) => state.rows.isEmpty
          ? Center(child: BaseText('Nenhuma compra encontrada'.hardcoded))
          : ScrollableTable<BuyMovementDataRowEntity>(
              items: state.rows,
              pdfFileName: 'Compras por período'.hardcoded,
              isLoading: value.isLoading,
              refreshProvider: provider,
              initialSortColumnIndex: 0,
              columns: [
                ScrollableTableColumnSpec(
                  headerTitle: 'Período'.hardcoded,
                  minWidth: Sizes.p120,
                  cellBuilder: (row) {
                    final DateFormatType formatType = switch (period) {
                      HomeBuyMovementPeriod.daily => .ddMMyyyy,
                      HomeBuyMovementPeriod.monthly => .MMM,
                      HomeBuyMovementPeriod.yearly => .yyyy,
                      _ => .ddMMyyyy,
                    };
                    return Column(
                      children: [
                        BaseText.bodyMedium(
                          row.date?.formatDate(formatType).toUpperCase() ?? '-',
                          textAlign: TextAlign.center,
                        ),
                        if (period == .daily)
                          BaseText.caption(row.date?.formatDate(.EEE) ?? ''),
                      ],
                    );
                  },
                  sortValueMapper: (row) => row.date ?? DateTime(0),
                  textValueMapper: (row) =>
                      row.date?.formatDate(.MMyyyy) ?? '-',
                ),
                ScrollableTableColumnSpec(
                  headerTitle: 'Valor'.hardcoded,
                  isMoney: true,
                  cellBuilder: (row) =>
                      BaseText.bodyMedium(row.totalValue.toString().toBRL()),
                  sortValueMapper: (row) => row.totalValue,
                  footerCellBuilder: (items) => BaseText.bodyMedium(
                    items
                        .fold<num>(0, (total, row) => total + row.totalValue)
                        .toString()
                        .toBRL(),
                  ),
                  footerTextValueMapper: (items) => items
                      .fold<num>(0, (total, row) => total + row.totalValue)
                      .toString()
                      .toBRL(),
                ),
              ],
            ),
    );
  }
}
