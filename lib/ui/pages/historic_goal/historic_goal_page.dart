// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../pages.dart';

bool _showAnimation = true;

class HistoricGoalPage extends StatefulWidget {
  final HistoricGoalPresenter presenter;
  const HistoricGoalPage({
    super.key,
    required this.presenter,
  });

  @override
  State<HistoricGoalPage> createState() => _HistoricGoalPageState();
}

class _HistoricGoalPageState extends State<HistoricGoalPage> {
  DateTime now = DateTime.now();
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        selectedYear = now.year;
        widget.presenter.loadHistoricSales(selectedYear);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.presenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) {
                widget.presenter.loadHistoricSales(selectedYear);
              },
              showDatePicker: false,
            ),
            body: Column(
              children: [
                Obx(() {
                  final sales = widget.presenter.selectedYearSalesStatistics;

                  final salesFromSelectedYear = sales
                      ?.filteredSales(
                    filterYear: selectedYear,
                  )
                      .where((e) {
                    if (selectedYear == 2025) {
                      return e.Month! > 7; //must show only sales from august
                    }
                    return true;
                  }).toList();

                  if (salesFromSelectedYear == null ||
                      salesFromSelectedYear.isEmpty) {
                    return EmptySales(isLoading: loadingSnap.data == true);
                  }

                  return ScrollableTableItem(
                    columnsWidths: [60, 100, 100, 60],
                    showAnimation: _showAnimation,
                    hideShowAnimation: () {
                      _showAnimation = false;
                    },
                    pdfFileName: R.string.goalHistory,
                    columnsIndexToSum: [1, 2],
                    titles: [
                      R.string.period,
                      R.string.goal,
                      R.string.sales,
                      R.string.result,
                    ]
                        .map((e) =>
                            PersonalizedTableCell(value: e, isTitle: true))
                        .toList(),
                    rowValues: salesFromSelectedYear.map((sale) {
                      final salePeriod = DateFormat("MM/yyyy", "pt_BR")
                          .format(DateTime(selectedYear, sale.Month!));

                      final goalValue = widget.presenter
                          .getGoalValue(selectedYear, sale.Month!);

                      final percentageValue =
                          ((sale.LiquidValue ?? 1) / goalValue) * 100;

                      return [
                        PersonalizedTableCell(value: salePeriod),
                        PersonalizedTableCell(
                          value: goalValue,
                          isMoney: true,
                        ),
                        PersonalizedTableCell(
                          value: sale.LiquidValue,
                          isMoney: true,
                        ),
                        PersonalizedTableCell(
                          value: percentageValue,
                          isPercentage: true,
                          decoration: BoxDecoration(
                            color: percentageValue < 100
                                ? Colors.red.withAlpha(50)
                                : Colors.green.withAlpha(50),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ];
                    }).toList(),
                  );

                  // return ListView.builder(
                  //   itemCount: salesFromSelectedYear.length,
                  //   itemBuilder: (context, index) {
                  //     final sale = salesFromSelectedYear[index];

                  //     return ListTile(
                  //       title: Text(
                  //           "${R.string.goal} $salePeriod: ${widget.presenter.getGoalValue(selectedYear, sale.Month!)}"),
                  //       subtitle: Text(
                  //           "${R.string.sales}: ${sale.LiquidValue.toString().toBrazilianNumber().addBrazilianCoin()}"),
                  //     );
                  //   },
                  // );
                }),
              ],
            ),
          );
        });
  }
}
