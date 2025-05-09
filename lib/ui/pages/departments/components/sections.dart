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
    final departmentColorMap = <String, Color>{};

    final grouped =
        saleMovements.fold<Map<String, List<SaleMovementViewModel>>>(
      <String, List<SaleMovementViewModel>>{},
      (map, sale) {
        final dept = sale.ProductDepartment ?? '';
        final sect = sale.ProductSection ?? '';
        final key = '$dept|$sect';

        map.putIfAbsent(key, () => []).add(sale);
        return map;
      },
    );

    return Column(
      children: [
        TableItem(
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
          rowValues: grouped.entries.map((entry) {
            // dept & section from the first item in the group
            final first = entry.value.first;
            final dept = first.ProductDepartment ?? '';
            final sect = first.ProductSection ?? '';

            // sum up this group
            final groupValue = entry.value.sumLiquidValue();
            final groupQty = entry.value.quantitySales();

            // assign a consistent color per department
            departmentColorMap.putIfAbsent(
                dept, () => generateColorFromString(dept));

            // calculate averages/shares
            final avgTicket = groupQty > 0 ? groupValue / groupQty : 0;
            final share = totalValue > 0 ? groupValue / totalValue * 100 : 0;

            return [
              PersonalizedTableCell(
                value: dept,
                subtile: sect,
                decoration: BoxDecoration(color: departmentColorMap[dept]),
              ),
              PersonalizedTableCell(value: groupValue, isMoney: true),
              PersonalizedTableCell(value: groupQty),
              PersonalizedTableCell(value: avgTicket, isMoney: true),
              PersonalizedTableCell(value: share, isPercentage: true),
            ];
          }).toList(),
        ),
      ],
    );
  }
}
