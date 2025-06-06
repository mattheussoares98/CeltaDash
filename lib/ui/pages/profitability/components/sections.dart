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
    final departmentColorMap = <String, Color>{};

    return Column(
      children: [
        TableItem(
          columnIndexToCompareAndDetachBetterAndWorstValue: 3,
          columnsIndexToSum: [1, 2, 3],
          titleMinHeight: 43,
          indexToSort: 3,
          tableColumnWidth: {
            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.24),
            4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15),
          },
          titles: [
            PersonalizedTableCell(value: R.string.section),
            PersonalizedTableCell(value: R.string.total),
            PersonalizedTableCell(value: R.string.cost),
            PersonalizedTableCell(value: R.string.profit),
            PersonalizedTableCell(value: R.string.margin),
          ],
          rowValues: saleMovements
              .fold<Map<String, List<SaleMovementViewModel>>>(
                <String, List<SaleMovementViewModel>>{},
                (map, sale) {
                  final sect = sale.ProductSection.toString();

                  map.putIfAbsent(sect, () => []).add(sale);
                  return map;
                },
              )
              .entries
              .map((entry) {
                final sales = entry.value;
                final section = entry.key;
                final dept = entry.value.first.ProductDepartment.toString();

                departmentColorMap.putIfAbsent(
                    dept, () => generateColorFromString(dept));

                final liquidValue = sales.sumLiquidValue();
                final cost = sales.sumCost();
                final profit = liquidValue - cost;
                final percentage =
                    liquidValue == 0 ? 0.0 : (profit / liquidValue) * 100;

                return [
                  PersonalizedTableCell(
                    value: sales.first.ProductDepartment,
                    subtile: section,
                    decoration: BoxDecoration(color: departmentColorMap[dept]),
                  ),
                  PersonalizedTableCell(value: liquidValue, isMoney: true),
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
