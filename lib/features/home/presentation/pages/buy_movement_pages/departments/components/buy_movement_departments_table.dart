import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class BuyMovementDepartmentsTable extends StatelessWidget {
  const BuyMovementDepartmentsTable({
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
      pdfFileName: 'Compras por departamento'.hardcoded,
      fixFirstColumn: true,
      isLoading: isLoading,
      refreshProvider: refreshProvider,
      initialSortColumnIndex: 1,
      initialSortAscending: false,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle:
              "${'Departamento'.hardcoded} ${rows.isEmpty ? '' : '(${rows.length})'}",
          minWidth: 200,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.productDepartment?.name ?? '-'),
          sortValueMapper: (row) => row.productDepartment?.name ?? '',
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
          footerTextValueMapper: (_) => rows
              .fold<num>(0, (total, row) => total + row.totalValue)
              .toString()
              .toBRL(),
        ),
      ],
    );
  }
}
