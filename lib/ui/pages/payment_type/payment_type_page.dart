import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

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
  bool selectedMonth = false;
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedMonth
                    ? DateFormat.yMMM('pt_BR')
                        .format(homePresenter.selectedDate)
                    : DateFormat.yMMMd('pt_BR')
                        .format(homePresenter.selectedDate),
              ),
            ),
            SelectDayOrMonthButtons(
              selectedMonth: selectedMonth,
              updateSelectedMonth: (value) {
                setState(() {
                  selectedMonth = value;
                });
              },
            ),
            const SizedBox(height: 10),
            if (saleMovementsByModality != null && !selectedMonth)
              PaymentsGroupedByTypeAndDay(
                saleMovementsByModality: saleMovementsByModality,
              ),
            if (saleMovementsByModality != null && selectedMonth)
              PaymentsGroupedByMonth(
                saleMovementsByModality: saleMovementsByModality,
              ),
          ],
        );
      }),
    );
  }
}
