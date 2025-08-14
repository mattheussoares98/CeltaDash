import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        mainErrorSubscription =
            handleMainError(context, presenter.mainErrorStream);
        loadingSubscription = handleLoading(context, presenter.isLoadingStream);

        presenter.getSales(now: DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final compareMonthsPresenter = Get.find<CompareMonthsPresenter>();

    bool hasPreviousYearSales = compareMonthsPresenter.previousYear != null;

    return Scaffold(
      appBar: DefaultAppBar(
        showDatePicker: false,
        onChangeEnterprise: (_) {},
      ),
      body: ScrollableTableItem(
        titleMinHeight: isPortrait ? 40 : 25,
        fixFirstColumn: true,
        pdfFileName: R.string.compareMonths,
        indexToSort: 0,
        columnIndexToCompareAndDetachBetterAndWorstValue: 3,
        columnsIndexToSum: [0, 1, 2],
        columnsWidths: [80, 75, 75],
        showAnimation: _showAnimation,
        hideShowAnimation: () {
          _showAnimation = false;
        },
        titles: [
          const PersonalizedTableCell(
            value: "current month",
            isTitle: true,
          ),
          const PersonalizedTableCell(
            value: "previous month",
            isTitle: true,
          ),
          if (hasPreviousYearSales)
            const PersonalizedTableCell(
              value: "previous year",
              isTitle: true,
            ),
          PersonalizedTableCell(
            value: R.string.difference,
            isTitle: true,
          ),
        ],
        rowValues: [].map((e) {
          return [
            PersonalizedTableCell(
              value: e[0],
            ),
            PersonalizedTableCell(
              value: e[1],
            ),
            PersonalizedTableCell(
              value: e[2],
            ),
            PersonalizedTableCell(
              value: e[3],
            ),
          ];
        }).toList(),
      ),
    );
  }
}
