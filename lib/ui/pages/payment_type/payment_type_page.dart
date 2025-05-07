import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
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
  int selectedPageIndex = 0;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Get.find();

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

  void updateSelectedMonth(bool value) {
    setState(() {
      selectedMonth = value;
    });
  }

  bool filter(SaleMovementViewModel sale, HomePresenter homePresenter) {
    final selectedDate = homePresenter.selectedDate;

    return (selectedMonth ? true : sale.Date?.day == selectedDate.day) &&
        sale.Date?.month == selectedDate.month &&
        sale.Date?.year == selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, widget.paymentTypePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.paymentTypePresenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeEnterprise: (_) async {
          await widget.paymentTypePresenter.getSales(homePresenter);
        },
        onTapRefresh: () async {
          await widget.paymentTypePresenter
              .getSales(homePresenter, forceRefresh: true);
        },
        onChangeDate: (newDate) async {
          await widget.paymentTypePresenter.getSales(homePresenter);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectDayOrMonthButtons(
              selectedMonth: selectedMonth,
              updateSelectedMonth: updateSelectedMonth,
            ),
          ),
          StreamBuilder<bool>(
              stream: homePresenter.updateScreenStream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const SizedBox.shrink();
                }

                return Obx(() {
                  final saleMovements = (selectedPageIndex == 1
                          ? widget
                              .paymentTypePresenter.saleMovementsByFinalizations
                          : widget.paymentTypePresenter.saleMovements)
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel());

                  if (saleMovements == null || saleMovements.isEmpty) {
                    return NoSalesWereFound();
                  }

                  return PaymentsModalities(
                    filterByFinalizations: selectedPageIndex == 1,
                    saleMovements: saleMovements.where(
                      (element) {
                        return filter(element, homePresenter);
                      },
                    ).toList(),
                  );
                });
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedPageIndex: selectedPageIndex,
        updateSelectedPageIndex: (value) {
          if (value == selectedPageIndex) return;
          setState(() {
            selectedPageIndex = value;
          });
        },
      ),
    );
  }
}
