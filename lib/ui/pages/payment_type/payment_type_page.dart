import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool selectedMonth = false;
  int selectedPageIndex = 0;
  // StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        PaymentTypePresenter paymentTypePresenter = Get.find();
        paymentTypePresenter.emitLoadingAgain();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    pageController.dispose();
  }

  void updateSelectedMonth(bool value) {
    setState(() {
      selectedMonth = value;
    });
  }

  bool filter(SaleMovementViewModel sale, HomePresenter homePresenter) {
    final selectedDate = homePresenter.selectedDate;

    if (selectedMonth) {
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
    DepartmentsPresenter departmentsPresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();

    // loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    // loadingSubscription =
    //     handleLoading(context, paymentTypePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, paymentTypePresenter.mainErrorStream);

    return StreamBuilder<bool>(
        stream: paymentTypePresenter.isLoadingStream,
        builder: (context, isLoadingPayments) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: isLoadingPayments.data == true,
              onChangeEnterprise: (_) {
                homePresenter.reloadAllData(
                  salesPresenter,
                  resumePresenter,
                  paymentTypePresenter,
                  productsPresenter,
                  departmentsPresenter,
                );
              },
              onChangeDate: (_) {
                homePresenter.reloadAllData(
                  salesPresenter,
                  resumePresenter,
                  paymentTypePresenter,
                  productsPresenter,
                  departmentsPresenter,
                );
              },
              onTapRefresh: () {
                homePresenter.reloadAllData(
                  salesPresenter,
                  resumePresenter,
                  paymentTypePresenter,
                  productsPresenter,
                  departmentsPresenter,
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
                      selectedMonth: selectedMonth,
                      updateSelectedMonth: updateSelectedMonth,
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
                                    return filter(element, homePresenter);
                                  },
                                ).toList(),
                              ),
                              PaymentsModalities(
                                filterByFinalizations: true,
                                saleMovements:
                                    saleMovementsByFinalizations.where(
                                  (element) {
                                    return filter(element, homePresenter);
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
