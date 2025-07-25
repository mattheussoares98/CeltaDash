import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

bool _showAnimation = true;

class PersonalizedTable extends StatelessWidget {
  const PersonalizedTable({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<PersonalizedPresenter>();

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final remainingSpace = constraints.remainingPaintExtent;
        const minHeight = 300.0;

        // The height of our table area should be the larger of the two values.
        final extent = remainingSpace > minHeight ? remainingSpace : minHeight;

        return SliverToBoxAdapter(
          child: SizedBox(
            height: extent,
            child: Obx(() {
              final sales = presenter.saleStatistics;
              if (sales == null || sales.isEmpty) {
                return const SizedBox.shrink();
              }

              // 1. Define all possible columns in one place.
              // This map links a title to its check rule and its value getter.
              final columnDefinitions = <String,
                  ({
                bool Function(SaleStatisticViewModel) check,
                String Function(SaleStatisticViewModel) getValue,
                double width,
              })>{
                R.string.enterprise: (
                  width: 100,
                  check: (s) => s.EnterpriseFantasyName != null,
                  getValue: (s) => s.EnterpriseFantasyName ?? "",
                ),
                R.string.year: (
                  width: 70,
                  check: (s) => s.Year != null,
                  getValue: (s) => s.Year ?? "",
                ),
                R.string.month: (
                  width: 70,
                  check: (s) => s.Month != null,
                  getValue: (s) {
                    final date = DateTime(0, s.Month!.toInt());
                    return DateFormat.MMM("pt_BR")
                        .format(date)
                        .toUpperCase()
                        .replaceAll(RegExp(r'\.'), '');
                  },
                ),
                R.string.hour: (
                  width: 70,
                  check: (s) => s.Hour != null,
                  getValue: (s) {
                    final formatter = DateFormat("y/MM/dd", "pt_BR");
                    final hour = s.Hour?.replaceAll(RegExp(r'\n'), '~');
                    return "$hour\n${formatter.format(s.Date!)}";
                  }
                ),
                R.string.product: (
                  width: 200,
                  check: (s) => s.Product != null,
                  getValue: (s) {
                    final parts = s.Product?.split('-');
                    return parts?.length != null && parts!.length > 2
                        ? parts[2]
                        : '';
                  }
                ),
                R.string.productsQuantityAbbreviated: (
                  width: 80,
                  check: (s) => s.QuantityOfProducts != null,
                  getValue: (s) => s.QuantityOfProducts ?? ""
                ),
                R.string.departmentAbbreviated: (
                  width: 150,
                  check: (s) => s.ProductDepartment != null,
                  getValue: (s) => s.ProductDepartment ?? ""
                ),
                R.string.section: (
                  width: 170,
                  check: (s) => s.ProductSection != null,
                  getValue: (s) => s.ProductSection ?? ""
                ),
                R.string.finalization: (
                  width: 170,
                  check: (s) => s.PaymentFinalization != null,
                  getValue: (s) => s.PaymentFinalization ?? ""
                ),
                R.string.paymentsType: (
                  width: 120,
                  check: (s) => s.PaymentModality != null,
                  getValue: (s) => s.PaymentModality ?? ""
                ),
                R.string.salesQuantityAbbreviated: (
                  width: 60,
                  check: (s) => s.QuantitySales != null,
                  getValue: (s) => s.QuantitySales ?? ""
                ),
                R.string.operator: (
                  width: 200,
                  check: (s) => s.CashierOperator != null,
                  getValue: (s) => s.CashierOperator ?? ""
                ),
                R.string.seller: (
                  width: 200,
                  check: (s) => s.Seller != null,
                  getValue: (s) => s.Seller ?? ""
                ),
                R.string.cost: (
                  width: 100,
                  check: (s) => s.TotalRepositionCost != null,
                  getValue: (s) => s.TotalRepositionCost ?? ""
                ),
                R.string.quantityAbbreviated: (
                  width: 100,
                  check: (s) => s.QuantityOfProducts != null,
                  getValue: (s) => s.QuantityOfProducts ?? ""
                ),
                R.string.total: (
                  width: 120,
                  check: (s) => s.LiquidValue != null,
                  getValue: (s) => s.LiquidValue ?? "",
                ),
              };

              // 2. Determine which columns are active in a single pass.
              final remainingChecks = columnDefinitions.keys.toSet();
              final populatedTitles = <String>{};
              for (final sale in sales) {
                if (remainingChecks.isEmpty) break;
                final foundInThisPass = <String>{};
                for (final title in remainingChecks) {
                  if (columnDefinitions[title]!.check(sale)) {
                    populatedTitles.add(title);
                    foundInThisPass.add(title);
                  }
                }
                remainingChecks.removeAll(foundInThisPass);
              }

              // This is the final, ordered list of titles for the active columns.
              final activeTitles = columnDefinitions.keys
                  .where(populatedTitles.contains)
                  .toList();

              // 3. Generate the rows using the active titles.
              final tableRows = sales.map((sale) {
                // For each sale, create a row.
                return activeTitles.map((title) {
                  // For each active title, get the corresponding value from the sale.
                  dynamic value = columnDefinitions[title]!.getValue(sale);
                  bool isMoney =
                      title == R.string.total || title == R.string.cost;

                  if (title == R.string.year) {
                    value = value.toString();
                  } else if (double.tryParse(value) != null) {
                    value = value.toString().toDouble();
                  }

                  return PersonalizedTableCell(
                    value: value,
                    isMoney: isMoney,
                  );
                }).toList();
              }).toList();

              final columnWidths = activeTitles
                  .map((title) => columnDefinitions[title]!.width)
                  .toList();

              final totalIndex =
                  activeTitles.indexWhere((e) => e == R.string.total);
              final costIndex =
                  activeTitles.indexWhere((e) => e == R.string.cost);
              final quantityAbbreviatedIndex = activeTitles
                  .indexWhere((e) => e == R.string.quantityAbbreviated);
              final productsQuantityAbbreviatedIndex = activeTitles
                  .indexWhere((e) => e == R.string.productsQuantityAbbreviated);
              final salesQuantityAbbreviated = activeTitles
                  .indexWhere((e) => e == R.string.salesQuantityAbbreviated);

              final columnsToSum = [
                if (totalIndex != -1) totalIndex,
                if (costIndex != -1) costIndex,
                if (quantityAbbreviatedIndex != -1) quantityAbbreviatedIndex,
                if (productsQuantityAbbreviatedIndex != -1)
                  productsQuantityAbbreviatedIndex,
                if (salesQuantityAbbreviated != -1) salesQuantityAbbreviated,
              ];

              return ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 600),
                child: Column(
                  children: [
                    ScrollableTableItem(
                      columnIndexToCompareAndDetachBetterAndWorstValue:
                          activeTitles.length - 1,
                      indexToSort: activeTitles.length - 1,
                      titleMinHeight: 43,
                      fixFirstColumn: true,
                      columnsIndexToSum: columnsToSum,
                      titles: activeTitles
                          .map((title) => PersonalizedTableCell(
                              value: title, isTitle: true))
                          .toList(),
                      rowValues: tableRows,
                      columnsWidths: columnWidths, // Dynamic widths
                      showAnimation: _showAnimation,
                      hideShowAnimation: () {
                        _showAnimation = false;
                      },
                      pdfFileName: "Relatório Personalizado",
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
