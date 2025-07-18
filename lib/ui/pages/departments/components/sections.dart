import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Sections extends StatelessWidget {
  final List<SaleStatisticViewModel> saleStatistics;

  const Sections({
    super.key,
    required this.saleStatistics,
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
    final departmentsPresenter = Get.find<DepartmentsPresenter>();
    final totalStatisticsLiquid = saleStatistics.sumLiquidValue();
    final departmentColorMap = <String, Color>{};

    final grouped =
        saleStatistics.fold<Map<String, List<SaleStatisticViewModel>>>(
      <String, List<SaleStatisticViewModel>>{},
      (map, sale) {
        final dept = sale.ProductDepartment ?? '';
        final sect = sale.ProductSection ?? '';
        final key = '$dept|$sect';

        map.putIfAbsent(key, () => []).add(sale);
        return map;
      },
    );

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      children: [
        ScrollableTableItem(
          titleMinHeight: isPortrait ? 50 : 35,
          selectedPeriodType: departmentsPresenter.selectedPeriod,
          pdfFileName: R.string.sections,
          showAnimation: false,
          hideShowAnimation: () {},
          animationSecondsDuration: 3,
          columnsWidths: [110, 85, 85, 85, 60, 55],
          fixFirstColumn: true,
          columnsIndexToSum: [1, 2, 3],
          columnIndexToCompareAndDetachBetterAndWorstValue: 3,
          indexToSort: 3,
          titles: [
            PersonalizedTableCell(
              value: R.string.sections.toUpperCase(),
              isTitle: true,
            ),
            PersonalizedTableCell(
                value: R.string.sales.toUpperCase(), isTitle: true),
            PersonalizedTableCell(
                value: R.string.cost.toUpperCase(), isTitle: true),
            PersonalizedTableCell(
                value: R.string.profit.toUpperCase(), isTitle: true),
            PersonalizedTableCell(
                value: R.string.margin.toUpperCase(), isTitle: true),
            PersonalizedTableCell(
                value: R.string.share.toUpperCase(), isTitle: true),
          ],
          rowValues: grouped.entries.map((entry) {
            // dept & section from the first item in the group
            final first = entry.value.first;
            final dept = first.ProductDepartment ?? '';
            final sect = first.ProductSection ?? '';
            // sum up this group
            final sectionValueLiquid = entry.value.sumLiquidValue();
            final cost = entry.value.sumCost();
            final profit = sectionValueLiquid - cost;
            final profitPercent = profit == 0 || totalStatisticsLiquid == 0
                ? 0
                : (profit / (sectionValueLiquid)) * 100;

            // assign a consistent color per department
            departmentColorMap.putIfAbsent(
                dept, () => generateColorFromString(dept));

            final share = totalStatisticsLiquid > 0
                ? sectionValueLiquid / totalStatisticsLiquid * 100
                : 0;

            return [
              PersonalizedTableCell(
                value: dept,
                subtile: sect,
                decoration: BoxDecoration(color: departmentColorMap[dept]),
              ),
              PersonalizedTableCell(value: sectionValueLiquid, isMoney: true),
              PersonalizedTableCell(value: cost, isMoney: true),
              PersonalizedTableCell(value: profit, isMoney: true),
              PersonalizedTableCell(value: profitPercent, isPercentage: true),
              PersonalizedTableCell(value: share, isPercentage: true),
            ];
          }).toList(),
        ),
        // TableItem(
        //   columnIndexToCompareAndDetachBetterAndWorstValue: 1,
        //   columnsIndexToSum: [1, 2],
        //   titleMinHeight: 43,
        //   tableColumnWidth: {
        //     2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
        //     3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
        //     4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.17),
        //   },
        //   titles: [
        //     PersonalizedTableCell(value: R.string.sections),
        //     PersonalizedTableCell(value: R.string.sales),
        //     PersonalizedTableCell(value: R.string.quantityAbbreviated),
        //     PersonalizedTableCell(value: R.string.ticketAverage),
        //     PersonalizedTableCell(value: R.string.share),
        //   ],
        //   rowValues: grouped.entries.map((entry) {
        //     // dept & section from the first item in the group
        //     final first = entry.value.first;
        //     final dept = first.ProductDepartment ?? '';
        //     final sect = first.ProductSection ?? '';

        //     // sum up this group
        //     final groupValue = entry.value.sumLiquidValue();
        //     final groupQty = entry.value.quantitySales();

        //     // assign a consistent color per department
        //     departmentColorMap.putIfAbsent(
        //         dept, () => generateColorFromString(dept));

        //     // calculate averages/shares
        //     final avgTicket = groupQty > 0 ? groupValue / groupQty : 0;
        //     final share = totalStatisticsLiquid > 0
        //         ? groupValue / totalStatisticsLiquid * 100
        //         : 0;

        //     return [
        //       PersonalizedTableCell(
        //         value: dept,
        //         subtile: sect,
        //         decoration: BoxDecoration(color: departmentColorMap[dept]),
        //       ),
        //       PersonalizedTableCell(value: groupValue, isMoney: true),
        //       PersonalizedTableCell(value: groupQty),
        //       PersonalizedTableCell(value: avgTicket, isMoney: true),
        //       PersonalizedTableCell(value: share, isPercentage: true),
        //     ];
        //   }).toList(),
        // ),
      ],
    );
  }
}
