import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';

class CompareDaysPage extends StatefulWidget {
  const CompareDaysPage({super.key});

  @override
  State<CompareDaysPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<CompareDaysPage> {
  DateTime firstDate = DateTime.now().subtract(Duration(days: 1));
  DateTime secondDate = DateTime.now();
  List<List<PersonalizedTableCell>> rowValues = [];

  @override
  void initState() {
    super.initState();
    rowValues = getRowValues();
  }

  List<List<PersonalizedTableCell>> getRowValues() {
    final formatador = DateFormat.Hm(); // Formato: 00:00
    return List.generate(24, (i) {
      final inicio = formatador.format(DateTime(0, 1, 1, i));
      final fim = formatador.format(DateTime(0, 1, 1, i, 59));
      return '$inicio\n$fim';
    }).map((e) {
      final firstTotal = Random().nextDouble() * 5000;
      final secondTotal = Random().nextDouble() * 5000;

      totalFirstDay += firstTotal;
      totalSecondDay += secondTotal;

      return [
        PersonalizedTableCell(value: e),
        PersonalizedTableCell(value: firstTotal),
        PersonalizedTableCell(value: secondTotal),
        PersonalizedTableCell(
          value: secondTotal == 0
              ? 100
              : getTotalDifference(first: firstTotal, second: secondTotal),
          isPercentage: true,
        ),
      ];
    }).toList();
  }

  double totalFirstDay = 0.0;
  double totalSecondDay = 0.0;

  double getTotalDifference({required double first, required double second}) {
    if (first > second) {
      return (first / second - 1) * 100;
    } else {
      return -((second - first) / first) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hourWidth = MediaQuery.of(context).size.width * 0.2;
    final dayWidth = MediaQuery.of(context).size.width * 0.3;
    final compareDaysWidth = MediaQuery.of(context).size.width * 0.2;

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: () {},
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
                  date: firstDate,
                  updateDate: (newDate) {
                    setState(() {
                      firstDate = newDate;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: SelectDateButton(
                  date: secondDate,
                  updateDate: (newDate) {
                    setState(() {
                      secondDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
            rowValues: rowValues,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TotalSalesByDay(
                        date: firstDate,
                        totalSales: totalFirstDay,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TotalSalesByDay(
                        date: secondDate,
                        totalSales: totalSecondDay,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DayComparison(
                  firstDate: firstDate,
                  secondDate: secondDate,
                  totalDifference: getTotalDifference(
                    first: totalFirstDay,
                    second: totalSecondDay,
                  ),
                  totalFirstDay: totalFirstDay,
                  totalSecondDay: totalSecondDay,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
