import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:celta_dash/features/sales/presentation/models/models.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';

class SalesTable extends StatelessWidget {
  const SalesTable({
    required this.sales,
    required this.refreshProvider,
    this.isLoading = false,
    super.key,
  });

  final List<SaleMovementCollectionItemEntity> sales;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final rows = sales.map(SaleRowState.new).toList(growable: false);
    return ScrollableTable<SaleRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 2,
      onTapRow: (row) {
        final enterpriseId = row.sale.enterpriseId;
        final documentNumber = row.sale.documentNumber;
        final billingDate = row.sale.dateHourOfBilling;
        if (enterpriseId == null ||
            documentNumber == null ||
            billingDate == null) {
          return;
        }
        context.pushNamed(
          Routes.bsSaleDetails.name,
          pathParameters: {
            'enterpriseId': enterpriseId.toString(),
            'documentNumber': documentNumber,
            'billingTimestamp': billingDate.millisecondsSinceEpoch.toString(),
          },
        );
      },
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Cupom'.hardcoded,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.sale.documentNumber ?? '-'),
          sortValueMapper: (row) => row.sale.documentNumber ?? '',
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'PDV'.hardcoded,
          minWidth: 45,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.sale.cashierNumber ?? '-'),
          sortValueMapper: (row) => row.sale.cashierNumber ?? '',
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Data'.hardcoded,
          minWidth: 85,
          cellBuilder: (row) {
            final date = row.sale.dateHourOfBilling;
            if (date == null) {
              return const BaseText('-');
            }

            return Column(
              mainAxisAlignment: .spaceEvenly,
              children: [
                BaseText(date.formatDate()),
                BaseText(date.formatDate(.Hm)),
              ],
            );
          },
          sortValueMapper: (row) => row.sale.dateHourOfBilling ?? DateTime(0),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Total'.hardcoded,
          isMoney: true,
          cellBuilder: (row) => BaseText.bodyMedium(
            (row.sale.totalLiquid ?? 0).toString().toBRL(),
          ),
          sortValueMapper: (row) => row.sale.totalLiquid ?? 0,
          footerCellBuilder: (items) => BaseText.bodyMedium(
            items
                .fold<double>(
                  0,
                  (total, row) => total + (row.sale.totalLiquid ?? 0),
                )
                .toString()
                .toBRL(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Cancelada por'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.sale.userCancellation ?? 'Indefinido'.hardcoded,
          ),
          sortValueMapper: (row) => row.sale.userCancellation ?? '',
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Justificativa'.hardcoded,
          minWidth: 150,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.sale.motiveCancellation ?? 'Indefinido'.hardcoded,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          sortValueMapper: (row) => row.sale.motiveCancellation ?? '',
        ),
      ],
    );
  }
}
