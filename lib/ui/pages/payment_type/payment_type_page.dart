import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PaymentTypePage extends StatefulWidget {
  final PaymentTypePresenter paymentTypePresenter;
  const PaymentTypePage({
    super.key,
    required this.paymentTypePresenter,
  });

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with LoadingManager, UIErrorManager {
  bool selectedMonth = true;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Provider.of(context, listen: false);

        await widget.paymentTypePresenter.getSales(homePresenter);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, widget.paymentTypePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.paymentTypePresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(title: Text(R.string.paymentsType)),
      body: Obx(() {
        //TODO add option to search again
        final saleMovementsByModality =
            widget.paymentTypePresenter.saleMovements;
        final saleMovementsByFinalizations =
            widget.paymentTypePresenter.saleMovementsByFinalizations;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedMonth
                    ? DateFormat.yMMMd('pt_BR')
                        .format(homePresenter.selectedDate)
                    : DateFormat.yMMM('pt_BR')
                        .format(homePresenter.selectedDate),
              ),
            ),
            SelectPeriodItems(
              items: [
                SelectPeriodItems.createItem(
                  title: R.string.day,
                  onTap: () {
                    setState(() {
                      selectedMonth = true;
                    });
                    debugPrint("Filter by day");
                  },
                ),
                SelectPeriodItems.createItem(
                  title: R.string.month,
                  onTap: () {
                    setState(() {
                      selectedMonth = false;
                    });
                    debugPrint("Filter by month");
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (saleMovementsByModality != null)
              TableItem(
                titles: [
                  PersonalizedTableCell(value: R.string.paymentsType),
                  PersonalizedTableCell(value: R.string.total),
                  PersonalizedTableCell(value: R.string.ticketAverage),
                  PersonalizedTableCell(value: R.string.share),
                ],
                columnIndexToCompareAndDetachBetterAndWorstValue: 3,
                tableColumnWidth: {
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.17),
                },
                titleMinHeight: 40,
                indexToSort: 3,
                columnsIndexToSum: [1],
                rowValues: saleMovementsByModality.where((sale) {
                  final selectedDate = homePresenter.selectedDate;

                  return sale.Date?.day == selectedDate.day &&
                      sale.Date?.month == selectedDate.month &&
                      sale.Date?.year == selectedDate.year;
                }).map((e) {
                  return [
                    PersonalizedTableCell(value: e.PaymentModality),
                    PersonalizedTableCell(value: e.LiquidValue, isMoney: true),
                    PersonalizedTableCell(
                      value: (e.LiquidValue?.toDouble() ?? 0) /
                          (e.QuantitySales?.toInt() ?? 0),
                      isMoney: true,
                    ),
                    PersonalizedTableCell(
                      value: (e.LiquidValue?.toDouble() ?? 0) /
                          (saleMovementsByModality.sumLiquidValue()),
                      isPercentage: true,
                    ),
                  ];
                }).toList(),
              ),
          ],
        );
      }),
    );
  }
}
