import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

class Departments extends StatelessWidget {
  final List<SaleStatisticViewModel> saleStatistics;

  const Departments({
    super.key,
    required this.saleStatistics,
  });

  @override
  Widget build(BuildContext context) {
    final totalDepartmentsLiquid = saleStatistics.sumLiquidValue();
    final homePresenter = Get.find<DepartmentsPresenter>();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      children: [
        ScrollableTableItem(
          titleMinHeight: isPortrait ? 43 : 25,
          selectedPeriodType: homePresenter.selectedPeriod,
          pdfFileName: R.string.departments,
          showAnimation: _showAnimation,
          hideShowAnimation: () {
            _showAnimation = false;
          },
          animationSecondsDuration: 3,
          columnsWidths: [110, 85, 85, 85, 60, 55],
          fixFirstColumn: true,
          columnsIndexToSum: [1, 2, 3],
          columnIndexToCompareAndDetachBetterAndWorstValue: 3,
          indexToSort: 3,
          titles: [
            PersonalizedTableCell(
              value: R.string.departmentAbbreviated.toUpperCase(),
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
                final totalValue = sales.toList().sumLiquidValue();
                final cost = sales.sumCost();
                final profit = totalValue - cost;
                final profitPercent = profit == 0 || totalValue == 0
                    ? 0
                    : (profit / (totalValue)) * 100;
                final share = totalValue / totalDepartmentsLiquid * 100;

                return [
                  PersonalizedTableCell(value: department),
                  PersonalizedTableCell(value: totalValue, isMoney: true),
                  PersonalizedTableCell(value: cost, isMoney: true),
                  PersonalizedTableCell(value: profit, isMoney: true),
                  PersonalizedTableCell(
                      value: profitPercent, isPercentage: true),
                  PersonalizedTableCell(value: share, isPercentage: true),
                ];
              })
              .toList(),
        ),
      ],
    );
  }
}
