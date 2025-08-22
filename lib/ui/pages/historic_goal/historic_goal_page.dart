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
  static DateTime now = DateTime.now();
  int selectedYear = now.year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
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
            body: Column(
              children: [
                DefaultAppBar(
                  isLoading: loadingSnap.data == true,
                  onChangeEnterprise: (_) {
                    widget.presenter.loadHistoricSales(selectedYear);
                  },
                  showDatePicker: false,
                ),
                if (now.year > 2025)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<int>(
                        value: selectedYear,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: Theme.of(context).textTheme.bodyLarge,
                        iconSize: 24,
                        elevation: 16,
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        focusColor: Theme.of(context).colorScheme.primary,
                        hint: Text(selectedYear.toString()),
                        items: List.generate(now.year - 2025 + 1, (index) {
                          final year = 2025 + index;
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }),
                        onChanged: loadingSnap.data == true
                            ? null
                            : (year) {
                                if (year != null) {
                                  setState(() {
                                    selectedYear = year;
                                    widget.presenter
                                        .loadHistoricSales(selectedYear);
                                  });
                                }
                              },
                      ),
                      if (loadingSnap.data == true)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        )
                    ],
                  ),
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
