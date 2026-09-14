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
      rowHeight: 80,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle:
              "${'Produto'.hardcoded} ${rows.isEmpty ? '' : '(${rows.length})'}",
          minWidth: 200,
          cellBuilder: (row) => Column(
            crossAxisAlignment: .stretch,
            mainAxisAlignment: .spaceEvenly,
            children: [
              BaseText.caption(row.product?.priceLookupCode ?? '-'),
              Flexible(
                child: BaseRichText(
                  texts: [
                    BaseText(
                      ' ${row.product?.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    BaseText(
                      ' (${row.product?.packingAbbreviation} ${row.product?.packingQuantity.toString().toBRL(3, true)})',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),

          sortValueMapper: (row) => row.product?.name ?? '',
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Quantidade'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(
            row.product?.quantity.toString().toBRL(3, true) ?? '-',
          ),
          sortValueMapper: (row) => row.product?.quantity ?? 0,
          footerTextValueMapper: (row) {
            final total = rows.fold(0.0, (p, e) => p + e.product!.quantity);
            return total.toString().toBRL();
          },
          footerCellBuilder: (items) {
            final total = items.fold(0.0, (p, e) => p + e.product!.quantity);
            return BaseText.bodyMedium(total.toString().toBRL(3, true));
          },
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Valor'.hardcoded,
          isMoney: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.totalValue.toString().toBRL()),
          sortValueMapper: (row) => row.totalValue,
          footerCellBuilder: (items) {
            final total = items.fold(0.0, (p, e) => p + e.totalValue);
            return BaseText.bodyMedium(total.toString().toBRL());
          },
          footerTextValueMapper: (row) {
            final total = rows.fold(0.0, (p, e) => p + e.totalValue);
            return total.toString().toBRL();
          },
        ),
      ],
    );
  }
}
