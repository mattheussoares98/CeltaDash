import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
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

  bool filter(SaleMovementViewModel sale, HomePresenter homePresenter) {
    final selectedDate = homePresenter.selectedDate;

    return (selectedMonth ? true : sale.Date?.day == selectedDate.day) &&
        sale.Date?.month == selectedDate.month &&
        sale.Date?.year == selectedDate.year;
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
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: () async {
          await widget.paymentTypePresenter.getSales(homePresenter);
          Future.delayed(Duration.zero, () {
            setState(() {});
          });
        },
      ),
      body: Obx(() {
        //TODO add option to search again
        final saleMovementsByModality =
            widget.paymentTypePresenter.saleMovements;
        final saleMovementsByFinalizations =
            widget.paymentTypePresenter.saleMovementsByFinalizations;

        Future.delayed(Duration.zero, () {
          setState(() {});
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectDayOrMonthButtons(
                selectedMonth: selectedMonth,
                updateSelectedMonth: (value) {
                  setState(() {
                    selectedMonth = value;
                  });
                },
              ),
            ),
            if (saleMovementsByModality != null)
              Expanded(
                child: PaymentsModalities(
                  filterByModality: true,
                  saleMovements: saleMovementsByModality.where(
                    (element) {
                      return filter(element, homePresenter);
                    },
                  ).toList(),
                ),
              ),
            // if (saleMovementsByFinalizations != null)
            //   Expanded(
            //     child: PaymentsModalities(
            //       filterByModality: false,
            //       saleMovements: saleMovementsByFinalizations.where(
            //         (element) {
            //           return filter(element, homePresenter);
            //         },
            //       ).toList(),
            //     ),
            //   ),
          ],
        );
      }),
    );
  }
}
