import 'dart:async';
import 'dart:io';

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
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    pageController.dispose();
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
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
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
            body: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    SelectPeriodItems(
                      isLoading: loadingSnap.data,
                      selectedPeriodType: paymentTypePresenter.selectedPeriod,
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
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.creditcard
                                : Icons.credit_card,
                          ),
                          text: R.string.modalities,
                        ),
                        Tab(
                          icon: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.list_bullet
                                : Icons.receipt_long,
                          ),
                          text: R.string.sections,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(() {
                        final dailyStatistics =
                            paymentTypePresenter.dailyStatistics
                                ?.filteredSales(
                                  enterprise: homePresenter.selectedEnterprise,
                                  filterDay: homePresenter.selectedDate.day,
                                  filterMonth: homePresenter.selectedDate.month,
                                  filterYear: homePresenter.selectedDate.year,
                                )
                                .map((e) => e.toViewModel())
                                .toList();

                        final monthlyStatistics =
                            paymentTypePresenter.monthlyStatistics
                                ?.filteredSales(
                                  enterprise: homePresenter.selectedEnterprise,
                                  filterMonth: homePresenter.selectedDate.month,
                                  filterYear: homePresenter.selectedDate.year,
                                )
                                .map((e) => e.toViewModel())
                                .toList();

                        final sales = paymentTypePresenter.selectedPeriod ==
                                PeriodType.daily
                            ? dailyStatistics
                            : monthlyStatistics;

                        if (sales == null || sales.isEmpty == true) {
                          return EmptySales(isLoading: loadingSnap.data);
                        }

                        return TabBarView(
                          children: [
                            PaymentsModalities(
                              filterByFinalizations: false,
                              saleStatistics: sales,
                            ),
                            PaymentsModalities(
                              filterByFinalizations: true,
                              saleStatistics: sales,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
