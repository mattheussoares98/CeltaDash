import 'package:flutter/widgets.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductsTable extends StatelessWidget {
  final List<SaleStatisticViewModel>? sales;
  final bool isLoading;
  const ProductsTable(
      {super.key, required this.sales, required this.isLoading});

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
        PersonalizedTableCell(value: index + 1),
        PersonalizedTableCell(value: productName),
        PersonalizedTableCell(
            value: sale.LiquidValue?.toDouble(), isMoney: true),
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

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TableItem(
            titleMinHeight: 43,
            tableColumnWidth: {
              0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1),
              2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.22),
              3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
              4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
            },
            columnIndexToCompareAndDetachBetterAndWorstValue: 2,
            columnsIndexToSum: [2, 3],
            // indexToSort: 0,
            titles: [
              PersonalizedTableCell(
                value: R.string.positionAbbreviated.toUpperCase(),
              ),
              PersonalizedTableCell(value: R.string.product.toUpperCase()),
              PersonalizedTableCell(value: R.string.sales.toUpperCase()),
              PersonalizedTableCell(
                value: R.string.quantityAbbreviated.toUpperCase(),
              ),
              PersonalizedTableCell(value: R.string.averagePrice.toUpperCase()),
            ],
            rowValues: constructRows(sales!),
          ),
        ],
      );
    });
  }
}
