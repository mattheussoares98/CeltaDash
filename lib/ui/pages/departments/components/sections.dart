import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Sections extends StatelessWidget {
  final List<SaleMovementViewModel> saleMovements;

  const Sections({
    super.key,
    required this.saleMovements,
  });

  @override
  Widget build(BuildContext context) {
    final totalValue = saleMovements.sumLiquidValue();
    final quantitySales = saleMovements.quantitySales();

    return TableItem(
      columnIndexToCompareAndDetachBetterAndWorstValue: 1,
      columnsIndexToSum: [1, 2],
      titleMinHeight: 43,
      tableColumnWidth: {
        2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
        3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
        4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.17),
      },
      titles: [
        PersonalizedTableCell(
          value: R.string.department,
        ),
        PersonalizedTableCell(value: R.string.total),
        PersonalizedTableCell(value: R.string.sales),
        PersonalizedTableCell(value: R.string.ticketAverage),
        PersonalizedTableCell(value: R.string.share),
      ],
      rowValues: saleMovements.map((sale) {
        return [
          PersonalizedTableCell(
            value: sale.ProductDepartment,
            subtile: sale.ProductSection,
          ),
          PersonalizedTableCell(value: sale.LiquidValue, isMoney: true),
          PersonalizedTableCell(value: sale.QuantitySales),
          PersonalizedTableCell(
            value: (sale.QuantitySales?.toInt() ?? 0) > 0
                ? (sale.LiquidValue?.toInt() ?? 0) / quantitySales
                : 0,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: ((sale.LiquidValue?.toInt() ?? 0) / totalValue) * 100,
            isPercentage: true,
          ),
        ];
      }).toList(),
    );
  }
}
