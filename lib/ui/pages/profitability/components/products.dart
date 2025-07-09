import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Products extends StatelessWidget {
  const Products({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();

    final saleStatistics =
        productsPresenter.selectedPeriod == PeriodType.daily
            ? productsPresenter.dailyStatistics
            : productsPresenter.monthlyStatistics;

    if (saleStatistics == null || saleStatistics.isEmpty) {
      return const EmptySales(isLoading: false);
    }

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
          rowValues: saleStatistics.map((entry) {
            // final sales = entry.value;
            // final section = entry.key;
            // final dept = entry.value.first.ProductDepartment.toString();

            // departmentColorMap.putIfAbsent(
            //     dept, () => generateColorFromString(dept));

            // final liquidValue = sales.sumLiquidValue();
            // final cost = sales.sumCost();
            // final profit = liquidValue - cost;
            // final percentage =
            //     liquidValue == 0 ? 0.0 : (profit / liquidValue) * 100;
            // debugPrint(entry.key);

            return [
              const PersonalizedTableCell(
                value: "sales.first.ProductDepartment",
                // subtile: section,
                // decoration: BoxDecoration(color: departmentColorMap[dept]),
              ),
              const PersonalizedTableCell(value: "liquidValue", isMoney: true),
              const PersonalizedTableCell(value: "cost", isMoney: true),
              const PersonalizedTableCell(value: "profit", isMoney: true),
              const PersonalizedTableCell(value: "percentage", isPercentage: true),
            ];
          }).toList(),
        ),
      ],
    );
  }
}
