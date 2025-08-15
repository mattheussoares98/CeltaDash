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
              onChangeEnterprise: (_) {},
              isLoading: loadingSnap.data,
            ),
            body: Obx(() {
              final firstMonthSales = compareMonthsPresenter.firstMonthSales;
              final secondMonthSales = compareMonthsPresenter.secondMonthSales;

              if (firstMonthSales.isEmpty && secondMonthSales.isEmpty) {
                return EmptySales(isLoading: loadingSnap.data == true);
              }

              return Column(
                children: [
                  ScrollableTableItem(
                    titleMinHeight: isPortrait ? 40 : 25,
                    fixFirstColumn: true,
                    pdfFileName: R.string.compareMonths,
                    indexToSort: 0,
                    columnsIndexToSum: [1, 2],
                    columnsWidths: [60, 80, 80],
                    showAnimation: _showAnimation,
                    hideShowAnimation: () {
                      _showAnimation = false;
                    },
                    titles: [
                      const PersonalizedTableCell(
                        value: "DAY",
                        isTitle: true,
                      ),
                      const PersonalizedTableCell(
                        value: "First month",
                        isTitle: true,
                      ),
                      const PersonalizedTableCell(
                        value: "Second month",
                        isTitle: true,
                      ),
                    ],
                    //TODO insert the correct length
                    rowValues: List.generate(DateTime.now().day, (index) {
                      return [
                        PersonalizedTableCell(
                          value: index + 1,
                        ),
                        //TODO test in a customer that doesnt has sales in the current month
                        const PersonalizedTableCell(
                          value: 0,
                          isMoney: true,
                        ),
                        //TODO test in a customer that doesnt has sales in the previous year
                        const PersonalizedTableCell(
                          value: 0,
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
