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
                String Function(SaleStatisticViewModel) getValue
              })>{
                R.string.enterprise: (
                  check: (s) => s.EnterpriseFantasyName != null,
                  getValue: (s) => s.EnterpriseFantasyName ?? ""
                ),
                R.string.year: (
                  check: (s) => s.Year != null,
                  getValue: (s) => s.Year ?? ""
                ),
                R.string.month: (
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
                  check: (s) => s.Hour != null,
                  getValue: (s) {
                    final formatter = DateFormat("y/MM/dd", "pt_BR");
                    final hour = s.Hour?.replaceAll(RegExp(r'\n'), '~');
                    return "$hour\n${formatter.format(s.Date!)}";
                  }
                ),
                R.string.product: (
                  check: (s) => s.Product != null,
                  getValue: (s) => s.Product ?? ""
                ),
                R.string.departmentAbbreviated: (
                  check: (s) => s.ProductDepartment != null,
                  getValue: (s) => s.ProductDepartment ?? ""
                ),
                R.string.section: (
                  check: (s) => s.ProductSection != null,
                  getValue: (s) => s.ProductSection ?? ""
                ),
                R.string.finalization: (
                  check: (s) => s.PaymentFinalization != null,
                  getValue: (s) => s.PaymentFinalization ?? ""
                ),
                R.string.paymentsType: (
                  check: (s) => s.PaymentModality != null,
                  getValue: (s) => s.PaymentModality ?? ""
                ),
                R.string.salesQuantityAbbreviated: (
                  check: (s) => s.QuantitySales != null,
                  getValue: (s) => s.QuantitySales ?? ""
                ),
                R.string.operator: (
                  check: (s) => s.CashierOperator != null,
                  getValue: (s) => s.CashierOperator ?? ""
                ),
                R.string.seller: (
                  check: (s) => s.Seller != null,
                  getValue: (s) => s.Seller ?? ""
                ),
                R.string.cost: (
                  check: (s) => s.TotalRepositionCost != null,
                  getValue: (s) => s.TotalRepositionCost ?? ""
                ),
                R.string.products: (
                  check: (s) => s.QuantityOfProducts != null,
                  getValue: (s) => s.QuantityOfProducts ?? ""
                ),
                R.string.total: (
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
                  final value = columnDefinitions[title]!.getValue(sale);
                  return PersonalizedTableCell(
                    value: value,
                    isMoney: title == R.string.total || title == R.string.cost,
                  );
                }).toList();
              }).toList();

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
                      columnsIndexToSum: [
                        activeTitles.length - 1,
                        activeTitles.indexWhere(
                            (e) => e == R.string.salesQuantityAbbreviated),
                      ],
                      titles: activeTitles
                          .map((title) => PersonalizedTableCell(
                              value: title, isTitle: true))
                          .toList(),
                      rowValues: tableRows,
                      columnsWidths: List.generate(
                          activeTitles.length, (index) => 70), // Dynamic widths
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
