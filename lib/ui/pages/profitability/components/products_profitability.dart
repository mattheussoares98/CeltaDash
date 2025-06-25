import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductsProfitability extends StatelessWidget {
  final PeriodType selectedPeriod;
  const ProductsProfitability({
    super.key,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final productsPresenter = Get.find<ProductsPresenter>();

    final saleStatistics = selectedPeriod == PeriodType.daily
        ? productsPresenter.dailyStatistics
        : productsPresenter.monthlyStatistics;

    if (saleStatistics == null || saleStatistics.isEmpty) {
      return EmptySales(isLoading: false);
    }

    return Column(
      children: [
        TableItem(
          columnIndexToCompareAndDetachBetterAndWorstValue: 3,
          columnsIndexToSum: [1, 2, 3],
          indexToSort: 3,
          titleMinHeight: 43,
          tableColumnWidth: {
            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.25),
            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.19),
            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.22),
            // 4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
          },
          titles: [
            PersonalizedTableCell(value: R.string.product),
            PersonalizedTableCell(value: R.string.sales),
            PersonalizedTableCell(value: R.string.cost),
            PersonalizedTableCell(value: R.string.profit),
            // PersonalizedTableCell(value: R.string.margin),
          ],
          rowValues: saleStatistics
              .fold<Map<String, List<SaleStatisticViewModel>>>({}, (acc, sale) {
                final key = sale.Product ?? 'Undefined';
                acc.putIfAbsent(key, () => []).add(sale);
                return acc;
              })
              .entries
              .map((entry) {
                final parts = entry.key.split('-');
                final productName = parts.length > 2 ? parts[2] : '';

                final sales = entry.value;
                final totalValue = sales.fold<double>(
                    0, (sum, s) => sum + (s.LiquidValue?.toDouble() ?? 0));
                final cost = sales.fold<int>(
                    0, (sum, s) => sum + (s.TotalRepositionCost?.toInt() ?? 0));
                final profit = totalValue - cost;
                // final percentage =
                //     totalValue == 0 ? 0.0 : (profit / totalValue) * 100;

                return [
                  PersonalizedTableCell(value: productName),
                  PersonalizedTableCell(value: totalValue, isMoney: true),
                  PersonalizedTableCell(value: cost, isMoney: true),
                  PersonalizedTableCell(value: profit, isMoney: true),
                  // PersonalizedTableCell(value: percentage, isPercentage: true),
                ];
              })
              .toList(),
        ),
      ],
    );
  }
}
