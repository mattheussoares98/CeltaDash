import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

class SectionsPage extends StatefulWidget {
  const SectionsPage({super.key});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  bool selectedDay = true;

  @override
  Widget build(BuildContext context) {
    final maxSales = Random().nextDouble() * 100000;
    var combinedSales = 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(R.string.sections)),
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
              PersonalizedTableCell(value: R.string.total),
              PersonalizedTableCell(value: R.string.ticketAverage),
              PersonalizedTableCell(value: R.string.share),
            ],
            columnIndexToCompareAndDetachBetterAndWorstValue: 3,
            tableColumnWidth: {
              3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.17),
            },
            titleMinHeight: 40,
            indexToSort: 3,
            columnsIndexToSum: [1],
            rowValues:
                List.generate(10, (index) {
                  final totalSales =
                      index == 9
                          ? maxSales - combinedSales
                          : Random().nextDouble() * (maxSales / 4);
                  combinedSales += totalSales;

                  final quantitySales = Random().nextInt(999);

                  return [
                    PersonalizedTableCell(value: faker.food.dish()),
                    PersonalizedTableCell(value: totalSales, isMoney: true),
                    PersonalizedTableCell(
                      value: totalSales / quantitySales,
                      isMoney: true,
                    ),
                    PersonalizedTableCell(
                      value: totalSales / maxSales * 100,
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
