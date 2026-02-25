import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductsTable extends StatelessWidget {
  final List<SaleStatisticViewModel>? sales;
  final bool isLoading;
  final bool showAnimation;
  final VoidCallback hideShowAnimation;
  const ProductsTable({
    super.key,
    required this.sales,
    required this.isLoading,
    required this.showAnimation,
    required this.hideShowAnimation,
  });

  List<List<PersonalizedTableCell>> constructRows(
    List<SaleStatisticViewModel> saleStatistics,
  ) {
    final sorted = [...saleStatistics]..sort((a, b) =>
        (b.LiquidValue?.toDouble() ?? 0)
            .compareTo(a.LiquidValue?.toDouble() ?? 0));

    List<List<PersonalizedTableCell>> sales = [];

    for (var index = 0; index < saleStatistics.length; index++) {
      final sale = sorted[index];
      final parts = sale.Product?.split('-');
      final productName =
          parts?.length != null && parts!.length > 2 ? parts[2] : '';

      final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
          (sale.QuantityOfProducts?.toDouble() ?? 1);

      sales.add([
        // PersonalizedTableCell(value: index + 1),
        PersonalizedTableCell(value: productName),
        PersonalizedTableCell(
            value: sale.LiquidValue?.toDouble() ?? 0, isMoney: true),
        PersonalizedTableCell(value: sale.QuantityOfProducts?.toDouble()),
        PersonalizedTableCell(value: ticketAverage, isMoney: true),
      ]);
    }

    return sales;
  }

  @override
  Widget build(BuildContext context) {
    final productsPresenter = Get.find<ProductsPresenter>();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return ScrollableTableItem(
      getSalesStatisticsParams:
          productsPresenter.selectedPeriod == PeriodType.daily
              ? productsPresenter.lastGetDailyParams
              : productsPresenter.lastGetMonthlyParams,
      titleMinHeight: isPortrait ? 43 : 32,
      selectedPeriodType: productsPresenter.selectedPeriod,
      pdfFileName: R.string.products,
      showAnimation: showAnimation,
      hideShowAnimation: hideShowAnimation,
      animationSecondsDuration: 3,
      columnsWidths: [130, 100, 70, 70, 90, 90, 90, 60],
      fixFirstColumn: true,
      columnsIndexToSum: [1, 2, 4, 6],
      columnIndexToCompareAndDetachBetterAndWorstValue: 6,
      indexToSort: 5,
      titles: [
        PersonalizedTableCell(
          value:
              "${R.string.product.toUpperCase()}${isPortrait ? '' : ' (200)'}",
          isTitle: true,
          subtile: isPortrait ? "Top 200" : null,
        ),
        PersonalizedTableCell(
            value: R.string.sales.toUpperCase(), isTitle: true),
        PersonalizedTableCell(
          value: R.string.quantityAbbreviated.toUpperCase(),
          isTitle: true,
        ),
        PersonalizedTableCell(
          value: R.string.averagePrice.toUpperCase(),
          isTitle: true,
        ),
        PersonalizedTableCell(
            value: R.string.cost.toUpperCase(), isTitle: true),
        PersonalizedTableCell(
            value: R.string.costAverage.toUpperCase(), isTitle: true),
        PersonalizedTableCell(
            value: R.string.profit.toUpperCase(), isTitle: true),
        PersonalizedTableCell(
            value: R.string.margin.toUpperCase(), isTitle: true),
      ],
      rowValues: sales!.map((sale) {
        final parts = sale.Product?.split('-');
        final productName =
            parts?.length != null && parts!.length > 2 ? parts[2] : '';

        final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
            (sale.QuantityOfProducts?.toDouble() ?? 1);

        final profit = (sale.LiquidValue?.toDouble() ?? 0) -
            (sale.TotalRepositionCost?.toDouble() ?? 0);

        final profitPercent = profit == 0 || sale.LiquidValue?.toDouble() == 0
            ? 0
            : (profit / (sale.LiquidValue?.toDouble() ?? 0)) * 100;

        final costAverage = (sale.TotalRepositionCost?.toDouble() ?? 0) /
            (sale.QuantityOfProducts?.toDouble() ?? 1);
        return [
          // PersonalizedTableCell(value: index + 1),
          PersonalizedTableCell(value: productName),
          PersonalizedTableCell(
            value: sale.LiquidValue?.toDouble() ?? 0,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: sale.QuantityOfProducts?.toDouble() ?? 0,
          ),
          PersonalizedTableCell(value: ticketAverage, isMoney: true),
          PersonalizedTableCell(
            value: sale.TotalRepositionCost?.toDouble() ?? 0,
            isMoney: true,
          ),
          PersonalizedTableCell(
            value: costAverage,
            isMoney: true,
          ),
          PersonalizedTableCell(value: profit, isMoney: true),
          PersonalizedTableCell(value: profitPercent, isPercentage: true),
        ];
      }).toList(),
    );
  }
}
