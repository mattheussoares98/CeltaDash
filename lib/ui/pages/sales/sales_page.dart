import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: () {
          debugPrint("Search sales again");
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectPeriodItems(
                items: [
                  SelectPeriodItems.createItem(
                    title: R.string.hour,
                    onTap: () {},
                  ),
                  SelectPeriodItems.createItem(
                    title: R.string.day,
                    onTap: () {},
                  ),
                  SelectPeriodItems.createItem(
                    title: R.string.month,
                    onTap: () {},
                  ),
                  SelectPeriodItems.createItem(
                    title: R.string.year,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TableItem(
                tableColumnWidth: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
                },
                columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                titles: [
                  "",
                  R.string.totalSales.toUpperCase(),
                  R.string.share.toUpperCase(),
                ],
                rowValues:
                    List.generate(DateTime.now().day, (index) {
                      final now = DateTime.now();
                      final atualDate = DateTime(
                        now.year,
                        now.month,
                        index + 1,
                      );

                      final totalSales = Random().nextDouble() * 50000;

                      return [
                        PersonalizedTableCell(
                          value: atualDate.day,
                          subtile: DateFormat.EEEE(
                            "pt_BR",
                          ).format(atualDate).toUpperCase().substring(0, 3),
                        ),
                        PersonalizedTableCell(value: totalSales, isMoney: true),
                        PersonalizedTableCell(
                          value: (totalSales / 50000) * 3,
                          isPercentage: true,
                        ),
                      ];
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
