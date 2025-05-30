import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Products extends StatelessWidget {
  final bool selectedDay;

  const Products({
    super.key,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    final saleMovements = productsPresenter.saleMovements
        ?.filteredSales(
          enterprise: homePresenter.selectedEnterprise,
          filterDay: selectedDay ? homePresenter.selectedDate.day : null,
          filterMonth: homePresenter.selectedDate.month,
          filterYear: homePresenter.selectedDate.year,
        )
        .map((e) => e.toViewModel())
        .toList();

    if (saleMovements == null || saleMovements.isEmpty) {
      return EmptySales(isLoading: false);
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
          rowValues: saleMovements.map((entry) {
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
              PersonalizedTableCell(
                value: "sales.first.ProductDepartment",
                // subtile: section,
                // decoration: BoxDecoration(color: departmentColorMap[dept]),
              ),
              PersonalizedTableCell(value: "liquidValue", isMoney: true),
              PersonalizedTableCell(value: "cost", isMoney: true),
              PersonalizedTableCell(value: "profit", isMoney: true),
              PersonalizedTableCell(value: "percentage", isPercentage: true),
            ];
          }).toList(),
        ),
      ],
    );
  }
}
