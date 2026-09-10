import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class BuyMovementProductsTable extends StatelessWidget {
  const BuyMovementProductsTable({
    required this.rows,
    required this.refreshProvider,
    required this.isLoading,
    super.key,
  });

  final List<BuyMovementDataRowEntity> rows;
  final ProviderBase<AsyncValue<dynamic>> refreshProvider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ScrollableTable<BuyMovementDataRowEntity>(
      items: rows,
      pdfFileName: 'Produtos comprados'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 2,
      initialSortAscending: false,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Produto'.hardcoded,
          minWidth: Sizes.p120,
          cellBuilder: (row) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseText.caption(
                '${row.product?.code ?? '-'}-${row.product?.packingCode ?? '-'}',
              ),
              BaseText(
                row.product?.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          sortValueMapper: (row) => row.product?.name ?? '',
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Quantidade'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.product?.quantity.toString().toBRL() ?? '-',
          ),
          sortValueMapper: (row) => row.product?.quantity ?? 0,
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Valor'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.totalValue.toString().toBRL()),
          sortValueMapper: (row) => row.totalValue,
        ),
      ],
    );
  }
}
