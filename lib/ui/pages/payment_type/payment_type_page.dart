import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
  bool selectedDay = true;
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
    final maxSales = Random().nextDouble() * 100000;
    var combinedSales = 0.0;

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, widget.paymentTypePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.paymentTypePresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(title: Text(R.string.paymentsType)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedDay
                  ? DateFormat.yMMMd('pt_BR').format(DateTime.now())
                  : DateFormat.yMMM('pt_BR').format(DateTime.now()),
            ),
          ),
          SelectPeriodItems(
            items: [
              SelectPeriodItems.createItem(
                title: R.string.day,
                onTap: () {
                  setState(() {
                    selectedDay = true;
                  });
                  debugPrint("Search by day");
                },
              ),
              SelectPeriodItems.createItem(
                title: R.string.month,
                onTap: () {
                  setState(() {
                    selectedDay = false;
                  });
                  debugPrint("Search by month");
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
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
            rowValues: List.generate(5, (index) {
              final totalSales = index == 4
                  ? maxSales - combinedSales
                  : Random().nextDouble() * (maxSales / 4);
              combinedSales += totalSales;

              final quantitySales = Random().nextInt(999);
              final names = [
                "Crédito",
                "Dinheiro",
                "Débito",
                "PIX",
                "Outros",
              ];

              return [
                PersonalizedTableCell(value: names[index]),
                PersonalizedTableCell(value: totalSales, isMoney: true),
                PersonalizedTableCell(
                  value: totalSales / quantitySales,
                  isMoney: true,
                ),
                PersonalizedTableCell(
                  value: totalSales / maxSales * 100,
                  isPercentage: true,
                ),
              ];
            }).toList(),
          ),
        ],
      ),
    );
  }
}
