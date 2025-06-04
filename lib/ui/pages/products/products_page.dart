import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with UIErrorManager {
  StreamSubscription? mainErrorSubscription;

  bool selectedDay = true;
  List<List<PersonalizedTableCell>> constructRows(
    List<SaleMovementViewModel> saleMovements,
  ) {
    final sorted = [...saleMovements]..sort((a, b) =>
        (b.LiquidValue?.toDouble() ?? 0)
            .compareTo(a.LiquidValue?.toDouble() ?? 0));

    List<List<PersonalizedTableCell>> sales = [];

    for (var index = 0; index < saleMovements.length; index++) {
      final sale = sorted[index];
      final parts = sale.Product?.split('-');
      final productName =
          parts?.length != null && parts!.length > 2 ? parts[2] : '';

      final ticketAverage = (sale.LiquidValue?.toDouble() ?? 0) /
          (sale.QuantityOfProducts?.toDouble() ?? 1);

      sales.add([
        PersonalizedTableCell(value: index + 1),
        PersonalizedTableCell(value: productName),
        PersonalizedTableCell(
            value: sale.LiquidValue?.toDouble(), isMoney: true),
        PersonalizedTableCell(value: sale.QuantityOfProducts?.toDouble()),
        PersonalizedTableCell(value: ticketAverage, isMoney: true),
      ]);
    }

    return sales;
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    mainErrorSubscription =
        handleMainError(context, productsPresenter.mainErrorStream);

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: homePresenter.updateScreenStream,
          builder: (context, updateScreen) {
            return Obx(() {
              final saleMovements = productsPresenter.saleMovements
                  ?.filteredSales(
                    enterprise: homePresenter.selectedEnterprise,
                    filterDay:
                        selectedDay ? homePresenter.selectedDate.day : null,
                    filterMonth:
                        !selectedDay ? homePresenter.selectedDate.month : null,
                    filterYear: homePresenter.selectedDate.year,
                  )
                  .map((e) => e.toViewModel())
                  .toList();

              if (saleMovements == null || saleMovements.isEmpty) {
                return EmptySales(isLoading: false);
              }

              return Opacity(
                opacity: updateScreen.data == true ? 0 : 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectPeriodItems(
                      selectedPeriodType: PeriodType.daily,
                    ),
                    const SizedBox(height: 10),
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
                      rowValues: constructRows(saleMovements),
                    ),
                  ],
                ),
              );
            });
          }),
    );
  }
}
