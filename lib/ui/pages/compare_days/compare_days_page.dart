import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class CompareDaysPage extends StatefulWidget {
  final CompareDaysPresenter presenter;
  const CompareDaysPage({super.key, required this.presenter});

  @override
  State<CompareDaysPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<CompareDaysPage>
    with UIErrorManager, LoadingManager {
  static final _now = DateTime.now();
  final firstDay = DateTime(_now.year, _now.month, _now.day - 1);
  final secondDay = DateTime(_now.year, _now.month, _now.day);

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Provider.of(context, listen: false);
        await widget.presenter.getSales(
          firstDay: firstDay,
          secondDay: secondDay,
          homePresenter: homePresenter,
        );
        Future.delayed(Duration.zero, () {
          setState(() {});
        });
      }
    });
  }

  double getTotalDifference({required double first, required double second}) {
    if (first > second) {
      return (first / second - 1) * 100;
    } else {
      return -((second - first) / first) * 100;
    }
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final hourWidth = MediaQuery.of(context).size.width * 0.2;
    final dayWidth = MediaQuery.of(context).size.width * 0.3;
    final compareDaysWidth = MediaQuery.of(context).size.width * 0.2;
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: (_) {},
        showDatePicker: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(R.string.compareDays),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SelectDateButton(
                  date: widget.presenter.selectedFirstDay ?? firstDay,
                  updateDate: (newDate) async {
                    await widget.presenter.getSales(
                      firstDay: newDate,
                      secondDay:
                          widget.presenter.selectedSecondDay ?? secondDay,
                      homePresenter: homePresenter,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: SelectDateButton(
                  date: widget.presenter.selectedSecondDay ?? secondDay,
                  updateDate: (newDate) async {
                    await widget.presenter.getSales(
                      firstDay: newDate,
                      secondDay: newDate,
                      homePresenter: homePresenter,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.presenter.saleMovements != null)
            TableItem(
              titles: [
                PersonalizedTableCell(value: R.string.hour),
                PersonalizedTableCell(value: "${R.string.day} 1"),
                PersonalizedTableCell(value: "${R.string.day} 2"),
                PersonalizedTableCell(value: "1 > 2"),
              ],
              titleMinHeight: 40,
              indexToSort: 0,
              columnIndexToCompareAndDetachBetterAndWorstValue: 3,
              tableColumnWidth: {
                0: FixedColumnWidth(hourWidth),
                1: FixedColumnWidth(dayWidth),
                2: FixedColumnWidth(dayWidth),
                3: FixedColumnWidth(compareDaysWidth),
              },
              rowValues: widget.presenter.saleMovements!
                  .map((e) => e.Hour)
                  .whereType<String>()
                  .toSet()
                  .toList()
                  .map((hour) {
                final firstDay = widget.presenter.selectedFirstDay?.day;
                final secondDay = widget.presenter.selectedSecondDay?.day;

                final firstDayTotal = widget.presenter.saleMovements!
                    .where((e) => e.Hour == hour && e.Date!.day == firstDay)
                    .map((e) => e.LiquidValue?.toDouble() ?? 0)
                    .fold(0.0, (a, b) => a + b);

                final secondDayTotal = widget.presenter.saleMovements!
                    .where((e) => e.Hour == hour && e.Date!.day == secondDay)
                    .map((e) => e.LiquidValue?.toDouble() ?? 0)
                    .fold(0.0, (a, b) => a + b);

                final difference = firstDayTotal > 0
                    ? ((firstDayTotal - secondDayTotal) / firstDayTotal) * 100
                    : 0.0;

                return [
                  PersonalizedTableCell(value: hour),
                  PersonalizedTableCell(value: firstDayTotal, isMoney: true),
                  PersonalizedTableCell(value: secondDayTotal, isMoney: true),
                  PersonalizedTableCell(value: difference, isPercentage: true),
                ];
              }).toList(),
            ),
          if (widget.presenter.saleMovements != null)
            Builder(builder: (context) {
              final firstDayTotalLiquid =
                  widget.presenter.saleMovements!.sumLiquidValue(
                filterDay: widget.presenter.selectedFirstDay?.day,
              );
              final secondDayTotalLiquid =
                  widget.presenter.saleMovements!.sumLiquidValue(
                filterDay: widget.presenter.selectedSecondDay?.day,
              );

              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TotalSalesByDay(
                            date: firstDay,
                            totalSales: firstDayTotalLiquid,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TotalSalesByDay(
                            date:
                                widget.presenter.selectedSecondDay ?? secondDay,
                            totalSales: secondDayTotalLiquid,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DayComparison(
                      firstDate: widget.presenter.selectedFirstDay ?? firstDay,
                      secondDate:
                          widget.presenter.selectedSecondDay ?? secondDay,
                      totalDifference: getTotalDifference(
                        first: firstDayTotalLiquid,
                        second: secondDayTotalLiquid,
                      ),
                      totalFirstDay: firstDayTotalLiquid,
                      totalSecondDay: secondDayTotalLiquid,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
