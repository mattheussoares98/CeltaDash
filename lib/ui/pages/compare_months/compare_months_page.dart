import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main/utils/utils.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

bool _showAnimation = true;

class CompareMonthsPage extends StatefulWidget {
  const CompareMonthsPage({super.key});

  @override
  State<CompareMonthsPage> createState() => _CompareMonthsPageState();
}

class _CompareMonthsPageState extends State<CompareMonthsPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final presenter = Get.find<CompareMonthsPresenter>();
        mainErrorSubscription = handleMainError(
            NavigatorKey.key.currentState!.context, presenter.mainErrorStream);
        loadingSubscription = handleLoading(
            NavigatorKey.key.currentState!.context, presenter.isLoadingStream);

        presenter.getSales(now: DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final compareMonthsPresenter = Get.find<CompareMonthsPresenter>();

    return StreamBuilder(
        stream: compareMonthsPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              showDatePicker: false,
              onChangeEnterprise: (_) {
                compareMonthsPresenter.getSales(now: DateTime.now());
              },
              isLoading: loadingSnap.data,
            ),
            body: Obx(() {
              final sales = compareMonthsPresenter.mergedSales;

              bool hasSelectedMonth =
                  sales.containsKey(CompareMonthsPeriod.selectedMonth) &&
                      sales[CompareMonthsPeriod.selectedMonth]!.isNotEmpty;
              bool hasPreviousMonth =
                  sales.containsKey(CompareMonthsPeriod.previousMonth) &&
                      sales[CompareMonthsPeriod.previousMonth]!.isNotEmpty;
              bool hasPreviousYear =
                  sales.containsKey(CompareMonthsPeriod.previousYear) &&
                      sales[CompareMonthsPeriod.previousYear]!.isNotEmpty;

              if (sales.isEmpty || loadingSnap.data == true) {
                return EmptySales(isLoading: loadingSnap.data == true);
              }

              return Column(
                children: [
                  ScrollableTableItem(
                    titleMinHeight: isPortrait ? 40 : 25,
                    fixFirstColumn: true,
                    pdfFileName: R.string.compareMonths,
                    indexToSort: 0,
                    columnsIndexToSum: [1, 2, 3],
                    columnsWidths: [
                      60,
                      if (hasSelectedMonth) 80,
                      if (hasPreviousMonth) 80,
                      if (hasPreviousYear) 80,
                    ],
                    showAnimation: _showAnimation,
                    hideShowAnimation: () {
                      _showAnimation = false;
                    },
                    titles: [
                      const PersonalizedTableCell(
                        value: "DAY",
                        isTitle: true,
                      ),
                      if (hasSelectedMonth)
                        const PersonalizedTableCell(
                          value: "current month",
                          isTitle: true,
                        ),
                      if (hasPreviousMonth)
                        const PersonalizedTableCell(
                          value: "previous month",
                          isTitle: true,
                        ),
                      if (hasPreviousYear)
                        const PersonalizedTableCell(
                          value: "previous year",
                          isTitle: true,
                        ),
                    ],
                    //TODO insert the correct length
                    rowValues: List.generate(DateTime.now().day, (index) {
                      final selectedMonth = hasSelectedMonth
                          ? sales[CompareMonthsPeriod.selectedMonth]!
                              .where((e) => e.Date?.day == index + 1)
                              .toList()
                          : null;
                      final previousMonth = hasPreviousMonth
                          ? sales[CompareMonthsPeriod.previousMonth]!
                              .where((e) => e.Date?.day == index + 1)
                              .toList()
                          : null;
                      final previousYear = hasPreviousYear
                          ? sales[CompareMonthsPeriod.previousYear]!
                              .where((e) => e.Date?.day == index + 1)
                              .toList()
                          : null;

                      return [
                        if (hasSelectedMonth)
                          PersonalizedTableCell(
                            value: index + 1,
                          ),
                        //TODO test in a customer that doesnt has sales in the current month
                        if (hasPreviousMonth)
                          PersonalizedTableCell(
                            value: selectedMonth!.sumLiquidValue(),
                            isMoney: true,
                          ),
                        //TODO test in a customer that doesnt has sales in the previous month
                        if (hasPreviousYear)
                          PersonalizedTableCell(
                            value: previousMonth?.sumLiquidValue(),
                            isMoney: true,
                          ),
                        //TODO test in a customer that doesnt has sales in the previous year
                        PersonalizedTableCell(
                          value: previousYear?.sumLiquidValue(),
                          isMoney: true,
                        ),
                      ];
                    }),
                  ),
                ],
              );
            }),
          );
        });
  }
}
