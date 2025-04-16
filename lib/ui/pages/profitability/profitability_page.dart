import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

class ProfitabilityPage extends StatefulWidget {
  const ProfitabilityPage({super.key});

  @override
  State<ProfitabilityPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<ProfitabilityPage> {
  bool selectedDay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.profitability)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedDay
                  ? DateFormat.yMMMd('pt_BR').format(DateTime.now())
                  : DateFormat.yMMM('pt_BR').format(DateTime.now()),
            ),
          ),
          SelectPeriodItems(
            items: [
              SelectPeriodItems.createItem(
                title: R.string.day,
                onTap: () {
                  setState(() {
                    selectedDay = true;
                  });
                  debugPrint("Search by day");
                },
              ),
              SelectPeriodItems.createItem(
                title: R.string.month,
                onTap: () {
                  setState(() {
                    selectedDay = false;
                  });
                  debugPrint("Search by month");
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          TableItem(
            titles: [
              PersonalizedTableCell(value: R.string.section),
              PersonalizedTableCell(value: R.string.totalSales),
              PersonalizedTableCell(value: R.string.cost),
              PersonalizedTableCell(value: R.string.grossProfit),
              PersonalizedTableCell(value: R.string.grossMargin),
            ],
            columnIndexToCompareAndDetachBetterAndWorstValue: 4,
            tableColumnWidth: {
              4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15),
            },
            titleMinHeight: 40,
            indexToSort: 4,
            columnsIndexToSum: [1, 2, 3],
            rowValues:
                List.generate(10, (index) {
                  final totalSales = Random().nextDouble() * 3000;
                  final cost = totalSales * Random().nextDouble();
                  final grossProfit = totalSales - cost;

                  return [
                    PersonalizedTableCell(value: faker.company.name()),
                    PersonalizedTableCell(value: totalSales, isMoney: true),
                    PersonalizedTableCell(value: cost, isMoney: true),
                    PersonalizedTableCell(value: grossProfit, isMoney: true),
                    PersonalizedTableCell(
                      value: grossProfit / totalSales * 100,
                      isPercentage: true,
                    ),
                  ];
                }).toList(),
          ),
        ],
      ),
    );
  }
}
