import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({super.key});

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with LoadingManager, UIErrorManager {
  int selectedPageIndex = 0;
  StreamSubscription? mainErrorSubscription;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        PaymentTypePresenter paymentTypePresenter = Get.find();
        HomePresenter homePresenter = Get.find();
        paymentTypePresenter.getSales(homePresenter);
        paymentTypePresenter.emitLoadingAgain();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    pageController.dispose();
  }

  bool filter(
    SaleMovementViewModel sale,
    HomePresenter homePresenter,
    PaymentTypePresenter paymentTypePresenter,
  ) {
    final selectedDate = homePresenter.selectedDate;

    if (paymentTypePresenter.selectedPeriodType == PeriodType.monthly) {
      return sale.Date?.month == selectedDate.month &&
          sale.Date?.year == selectedDate.year;
    } else {
      return sale.Date?.day == selectedDate.day &&
          sale.Date?.month == selectedDate.month &&
          sale.Date?.year == selectedDate.year;
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    PaymentTypePresenter paymentTypePresenter = Get.find();

    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, paymentTypePresenter.mainErrorStream);

    return StreamBuilder<bool>(
        stream: paymentTypePresenter.isLoadingStream,
        builder: (context, isLoadingPayments) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: isLoadingPayments.data == true,
              onChangeEnterprise: (_) {
                paymentTypePresenter.getSales(homePresenter);
              },
              onChangeDate: (_) {
                paymentTypePresenter.getSales(homePresenter);
              },
              onTapRefresh: () {
                paymentTypePresenter.getSales(
                  homePresenter,
                  forceRefresh: true,
                );
              },
            ),
            body: Obx(() {
              final saleMovementsByFinalizations =
                  paymentTypePresenter.saleMovementsByFinalizations
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel());

              final saleMovementsByModalities =
                  paymentTypePresenter.saleMovements
                      ?.filteredSales(
                        enterprise: homePresenter.selectedEnterprise,
                      )
                      .map((e) => e.toViewModel());

              if (saleMovementsByFinalizations == null ||
                  saleMovementsByFinalizations.isEmpty ||
                  saleMovementsByModalities == null ||
                  saleMovementsByModalities.isEmpty) {
                return EmptySales(isLoading: isLoadingPayments.data);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectDayOrMonthButtons(
                      onTapMonthly: () {
                        paymentTypePresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.monthly,
                        );
                      },
                      onTapDaily: () {
                        paymentTypePresenter.getSales(
                          homePresenter,
                          periodType: PeriodType.daily,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<bool>(
                      stream: homePresenter.updateScreenStream,
                      builder: (context, snapshot) {
                        return Opacity(
                          opacity: snapshot.data == true ? 0 : 1,
                          child: PageView(
                            controller: pageController,
                            onPageChanged: (value) {
                              setState(() {
                                selectedPageIndex = value;
                              });
                            },
                            children: [
                              PaymentsModalities(
                                filterByFinalizations: false,
                                saleMovements: saleMovementsByModalities.where(
                                  (element) {
                                    return filter(
                                      element,
                                      homePresenter,
                                      paymentTypePresenter,
                                    );
                                  },
                                ).toList(),
                              ),
                              PaymentsModalities(
                                filterByFinalizations: true,
                                saleMovements:
                                    saleMovementsByFinalizations.where(
                                  (element) {
                                    return filter(
                                      element,
                                      homePresenter,
                                      paymentTypePresenter,
                                    );
                                  },
                                ).toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
            bottomNavigationBar: BottomNavBar(
              currentIndex: selectedPageIndex,
              onTap: (value) {
                setState(() {
                  selectedPageIndex = value;
                });
                if (pageController.hasClients) {
                  pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              items: [
                BottomNavItem(
                  materialIcon: Icon(Icons.credit_card),
                  cupertinoIcon: Icon(CupertinoIcons.creditcard),
                  label: R.string.modalities,
                ),
                BottomNavItem(
                  materialIcon: Icon(Icons.receipt_long),
                  cupertinoIcon: Icon(CupertinoIcons.list_bullet),
                  label: R.string.finalizations,
                ),
              ],
            ),
          );
        });
  }
}
