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

  Color generateColorFromString(String input) {
    final hash = input.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);
    return Color.fromARGB(100, r, g, b); // 50 alpha for light background color
  }

  @override
  Widget build(BuildContext context) {
    final totalValue = saleMovements.sumLiquidValue();
    final quantitySales = saleMovements.quantitySales();

    final departmentColorMap = <String, Color>{};

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
      rowValues: saleMovements
      
      .map((sale) {
        final department = sale.ProductDepartment ?? '';
        departmentColorMap.putIfAbsent(
            department, () => generateColorFromString(department));

        return [
          PersonalizedTableCell(
            value: sale.ProductDepartment,
            subtile: sale.ProductSection,
            decoration: BoxDecoration(color: departmentColorMap[department]),
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
