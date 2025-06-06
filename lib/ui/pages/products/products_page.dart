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
    ResumePresenter resumePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();

    mainErrorSubscription =
        handleMainError(context, productsPresenter.mainErrorStream);

    return StreamBuilder(
        stream: productsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                );
              },
              onChangeDate: (_) {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                );
              },
              onTapRefresh: () {
                homePresenter.reloadSales(
                  resumePresenter,
                  salesPresenter,
                  productsPresenter,
                  forceRefresh: true,
                );
              },
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectPeriodItems(
                    isLoading: loadingSnap.data,
                    selectedPeriodType: productsPresenter.selectedPeriodValue,
                    onTapDaily: () {
                      productsPresenter.getSales(
                        homePresenter,
                        periodType: PeriodType.daily,
                      );
                    },
                    onTapMonthly: () {
                      productsPresenter.getSales(
                        homePresenter,
                        periodType: PeriodType.monthly,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final dailySales = productsPresenter.dailySaleMovements
                        ?.filteredSales(
                          enterprise: homePresenter.selectedEnterprise,
                          filterMonth: homePresenter.selectedDate.month,
                          filterDay: productsPresenter.selectedPeriodValue ==
                                  PeriodType.daily
                              ? homePresenter.selectedDate.day
                              : null,
                          filterYear: homePresenter.selectedDate.year,
                        )
                        .map((e) => e.toViewModel())
                        .toList();

                    final monthlySales = productsPresenter.monthlySaleMovements
                        ?.filteredSales(
                          enterprise: homePresenter.selectedEnterprise,
                          filterMonth: homePresenter.selectedDate.month,
                          filterYear: homePresenter.selectedDate.year,
                        )
                        .map((e) => e.toViewModel())
                        .toList();

                    final sales = productsPresenter.selectedPeriodValue ==
                            PeriodType.daily
                        ? dailySales
                        : monthlySales;

                    if (sales == null || sales.isEmpty) {
                      return EmptySales(isLoading: loadingSnap.data == true);
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableItem(
                          titleMinHeight: 43,
                          tableColumnWidth: {
                            0: FixedColumnWidth(
                                MediaQuery.of(context).size.width * 0.1),
                            2: FixedColumnWidth(
                                MediaQuery.of(context).size.width * 0.22),
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
                                value: R.string.sales.toUpperCase()),
                            PersonalizedTableCell(
                              value: R.string.quantityAbbreviated.toUpperCase(),
                            ),
                            PersonalizedTableCell(
                                value: R.string.averagePrice.toUpperCase()),
                          ],
                          rowValues: constructRows(
                              productsPresenter.selectedPeriodValue ==
                                      PeriodType.daily
                                  ? dailySales!
                                  : monthlySales!),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        });
  }
}
