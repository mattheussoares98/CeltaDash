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
  List<List<PersonalizedTableCell>> constructRows(
    List<SaleMovementViewModel> saleMovements,
  ) {
    final sorted = [...saleMovements]..sort((a, b) =>
        (b.LiquidValue?.toDouble() ?? 0)
            .compareTo(a.LiquidValue?.toDouble() ?? 0));

    List<List<PersonalizedTableCell>> top200 = [];
    double othersTotalValue = 0;
    int othersTotalQuantity = 0;

    for (var index = 0; index < saleMovements.length; index++) {
      final sale = sorted[index];
      final parts = sale.Product?.split('-');
      final productName =
          parts?.length != null && parts!.length > 2 ? parts[2] : '';

      final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
          (sale.QuantitySales?.toInt() ?? 1);

      if (index < 200) {
        top200.add([
          PersonalizedTableCell(value: index + 1),
          PersonalizedTableCell(value: productName),
          PersonalizedTableCell(
              value: sale.LiquidValue?.toDouble(), isMoney: true),
          PersonalizedTableCell(value: sale.QuantitySales),
          PersonalizedTableCell(value: ticketAverage, isMoney: true),
        ]);
      } else {
        othersTotalValue += sale.LiquidValue?.toDouble() ?? 0;
        othersTotalQuantity += sale.QuantitySales?.toInt() ?? 0;
      }
    }

    if (othersTotalQuantity > 0 || othersTotalValue > 0) {
      final combinedTicketAverage = othersTotalValue /
          (othersTotalQuantity == 0 ? 1 : othersTotalQuantity);

      top200.insert(
          0,
          ([
            PersonalizedTableCell(value: 0),
            PersonalizedTableCell(value: R.string.anothersProducts),
            PersonalizedTableCell(value: othersTotalValue, isMoney: true),
            PersonalizedTableCell(value: othersTotalQuantity),
            PersonalizedTableCell(value: combinedTicketAverage, isMoney: true),
          ]));
    }

    return top200;
  }

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: homePresenter.updateScreenStream,
          builder: (context, updateScreen) {
            return Obx(() {
              final saleMovements = productsPresenter.saleMovements;
              final saleMovementsByEnterprise = saleMovements
                  ?.where((e) =>
                      e.EnterpriseId == homePresenter.selectedEnterprise?.id)
                  .toList();

              return Opacity(
                opacity: updateScreen.data == true ? 0 : 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    if ((saleMovements == null || saleMovements.isEmpty) &&
                        (saleMovementsByEnterprise == null ||
                            saleMovementsByEnterprise.isEmpty))
                      Image.asset("lib/ui/assets/images/empty_sales.png"),
                    if (saleMovementsByEnterprise != null &&
                        saleMovementsByEnterprise.isNotEmpty)
                      TableItem(
                        titleMinHeight: 43,
                        tableColumnWidth: {
                          0: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.1),
                          2: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.2),
                          3: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.13),
                          4: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.16),
                        },
                        columnIndexToCompareAndDetachBetterAndWorstValue: 2,
                        columnsIndexToSum: [2, 3],
                        // indexToSort: 0,
                        titles: [
                          PersonalizedTableCell(
                            value: R.string.positionAbbreviated.toUpperCase(),
                          ),
                          PersonalizedTableCell(
                              value: R.string.product.toUpperCase()),
                          PersonalizedTableCell(
                              value: R.string.revenue.toUpperCase()),
                          PersonalizedTableCell(
                            value: R.string.quantityAbbreviated.toUpperCase(),
                          ),
                          PersonalizedTableCell(
                              value: R.string.averagePrice.toUpperCase()),
                        ],
                        rowValues: constructRows(saleMovementsByEnterprise),
                      ),
                  ],
                ),
              );
            });
          }),
    );
  }
}
