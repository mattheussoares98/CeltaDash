import 'package:flutter/widgets.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductsTable extends StatelessWidget {
  final List<SaleStatisticViewModel>? sales;
  final bool isLoading;
  const ProductsTable({
    super.key,
    required this.sales,
    required this.isLoading,
  });

  List<List<PersonalizedTableCell>> constructRows(
    List<SaleStatisticViewModel> saleStatistics,
  ) {
    final sorted = [...saleStatistics]..sort((a, b) =>
        (b.LiquidValue?.toDouble() ?? 0)
            .compareTo(a.LiquidValue?.toDouble() ?? 0));

    List<List<PersonalizedTableCell>> sales = [];

    for (var index = 0; index < saleStatistics.length; index++) {
      final sale = sorted[index];
      final parts = sale.Product?.split('-');
      final productName =
          parts?.length != null && parts!.length > 2 ? parts[2] : '';

      final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
          (sale.QuantityOfProducts?.toDouble() ?? 1);

      sales.add([
        // PersonalizedTableCell(value: index + 1),
        PersonalizedTableCell(value: productName),
        PersonalizedTableCell(
            value: sale.LiquidValue?.toDouble() ?? 0, isMoney: true),
        PersonalizedTableCell(value: sale.QuantityOfProducts?.toDouble()),
        PersonalizedTableCell(value: ticketAverage, isMoney: true),
      ]);
    }

    return sales;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (sales == null || sales!.isEmpty) {
        return EmptySales(isLoading: isLoading);
      }

      return ScrollableTableItem(
        titleMinHeight: 43,
        columnsWidths: [150, 70, 50, 70],
        fixFirstColumn: true,
        columnsIndexToSum: [1, 2],
        columnIndexToCompareAndDetachBetterAndWorstValue: 1,
        indexToSort: 1,
        titles: [
          PersonalizedTableCell(value: R.string.product.toUpperCase()),
          PersonalizedTableCell(value: R.string.sales.toUpperCase()),
          PersonalizedTableCell(
            value: R.string.quantityAbbreviated.toUpperCase(),
          ),
          PersonalizedTableCell(value: R.string.averagePrice.toUpperCase()),
        ],
        rowValues: sales!.map((sale) {
          final parts = sale.Product?.split('-');
          final productName =
              parts?.length != null && parts!.length > 2 ? parts[2] : '';

          final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
              (sale.QuantityOfProducts?.toDouble() ?? 1);
          return [
            // PersonalizedTableCell(value: index + 1),
            PersonalizedTableCell(value: productName),
            PersonalizedTableCell(
              value: sale.LiquidValue?.toDouble() ?? 0,
              isMoney: true,
            ),
            PersonalizedTableCell(value: sale.QuantityOfProducts?.toDouble()),
            PersonalizedTableCell(value: ticketAverage, isMoney: true),
          ];
        }).toList(),
      );
    });
  }
}
