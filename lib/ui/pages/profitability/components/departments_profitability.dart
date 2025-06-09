import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class DepartmentsProfitability extends StatelessWidget {
  final List<SaleStatisticViewModel> salesDepartments;
  const DepartmentsProfitability({
    super.key,
    required this.salesDepartments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableItem(
          columnIndexToCompareAndDetachBetterAndWorstValue: 3,
          columnsIndexToSum: [1, 2, 3],
          indexToSort: 3,
          titleMinHeight: 43,
          tableColumnWidth: {
            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.24),
            4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15),
          },
          titles: [
            PersonalizedTableCell(value: R.string.departmentAbbreviated),
            PersonalizedTableCell(value: R.string.sales),
            PersonalizedTableCell(value: R.string.cost),
            PersonalizedTableCell(value: R.string.profit),
            PersonalizedTableCell(value: R.string.margin),
          ],
          rowValues: salesDepartments
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
                    0, (sum, s) => sum + (s.LiquidValue?.toDouble() ?? 0));
                final cost = sales.fold<int>(
                    0, (sum, s) => sum + (s.TotalRepositionCost?.toInt() ?? 0));
                final profit = totalValue - cost;
                final percentage =
                    totalValue == 0 ? 0.0 : (profit / totalValue) * 100;

                return [
                  PersonalizedTableCell(value: department),
                  PersonalizedTableCell(value: totalValue, isMoney: true),
                  PersonalizedTableCell(value: cost, isMoney: true),
                  PersonalizedTableCell(value: profit, isMoney: true),
                  PersonalizedTableCell(value: percentage, isPercentage: true),
                ];
              })
              .toList(),
        ),
      ],
    );
  }
}
