import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Departments extends StatelessWidget {
  final List<SaleStatisticViewModel> saleStatistics;

  const Departments({
    super.key,
    required this.saleStatistics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableItem(
          columnIndexToCompareAndDetachBetterAndWorstValue: 1,
          columnsIndexToSum: [1, 2],
          indexToSort: 1,
          titleMinHeight: 43,
          tableColumnWidth: {
            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.17),
            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
            4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
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
          rowValues: saleStatistics
              .fold<Map<String, List<SaleStatisticViewModel>>>({}, (acc, sale) {
                final key = sale.ProductDepartment ?? 'Undefined';
                acc.putIfAbsent(key, () => []).add(sale);
                return acc;
              })
              .entries
              .map((entry) {
                final department = entry.key;
                final sales = entry.value;
                final totalValue = sales.fold<double>(
                    0, (sum, s) => sum + (s.LiquidValue?.toDouble() ?? 1));
                final totalQuantity = sales.fold<int>(
                    0, (sum, s) => sum + (s.QuantitySales?.toInt() ?? 1));
                final overallValue = saleStatistics.toList().sumLiquidValue();
        
                return [
                  PersonalizedTableCell(value: department),
                  PersonalizedTableCell(value: totalValue, isMoney: true),
                  PersonalizedTableCell(value: totalQuantity),
                  PersonalizedTableCell(
                    value: totalQuantity > 0 ? totalValue / totalQuantity : 0,
                    isMoney: true,
                  ),
                  PersonalizedTableCell(
                    value: (totalValue / overallValue) * 100,
                    isPercentage: true,
                  ),
                ];
              })
              .toList(),
        ),
      ],
    );
  }
}
