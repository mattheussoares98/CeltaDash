import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();

    return Scaffold(
      body: Obx(() {
        final saleMovements = productsPresenter.saleMovements;
        if (saleMovements != null && saleMovements.isNotEmpty) {
          saleMovements.sort((a, b) => (b.LiquidValue?.toDouble() ?? 0)
              .compareTo(a.LiquidValue?.toDouble() ?? 0));
        }

        return Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SelectPeriodItems(
            //     items: [
            //       SelectPeriodItems.createItem(
            //         title:
            //             "200+ ${DateFormat.MMMd("pt_BR").format(DateTime.now())}",
            //         onTap: () {},
            //       ),
            //       SelectPeriodItems.createItem(
            //         title:
            //             "200+ ${DateFormat.MMMd("pt_BR").format(DateTime.now().subtract(Duration(days: 1)))}",
            //         onTap: () {},
            //       ),
            //     ],
            //   ),
            // ),
            //TODO add period items after Cardoso fix problems to load data
            const SizedBox(height: 10),
            if (saleMovements != null && saleMovements.isNotEmpty)
              TableItem(
                titleMinHeight: 43,
                tableColumnWidth: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1),
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1),
                  4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
                },
                columnIndexToCompareAndDetachBetterAndWorstValue: 2,
                columnsIndexToSum: [2, 3],
                indexToSort: 2,
                titles: [
                  PersonalizedTableCell(
                    value: R.string.positionAbbreviated.toUpperCase(),
                  ),
                  PersonalizedTableCell(value: R.string.product.toUpperCase()),
                  PersonalizedTableCell(value: R.string.revenue.toUpperCase()),
                  PersonalizedTableCell(
                    value: R.string.quantityAbbreviated.toUpperCase(),
                  ),
                  PersonalizedTableCell(
                      value: R.string.averagePrice.toUpperCase()),
                ],
                rowValues: saleMovements.map((sale) {
                  final index = saleMovements.indexOf(sale);

                  final parts = sale.Product?.split('-');
                  final productName = parts?.length != null && parts!.length > 2
                      ? parts[2]
                      : '';

                  final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
                      (sale.QuantitySales?.toInt() ?? 1);

                  return [
                    PersonalizedTableCell(value: index + 1),
                    PersonalizedTableCell(value: productName),
                    PersonalizedTableCell(
                        value: sale.LiquidValue, isMoney: true),
                    PersonalizedTableCell(value: sale.QuantitySales),
                    PersonalizedTableCell(value: ticketAverage, isMoney: true),
                  ];
                }).toList(),
              ),
          ],
        );
      }),
    );
  }
}
