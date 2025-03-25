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
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
                },
                titles: [
                  "",
                  R.string.totalSales.toUpperCase(),
                  R.string.share.toUpperCase(),
                ],
                rowValues:
                    List.generate(30, (index) {
                      final now = DateTime.now();
                      final atualDate = DateTime(
                        now.year,
                        now.month,
                        index + 1,
                      );

                      return [
                        PersonalizedTableCell(
                          value:
                              "${atualDate.day}\n${DateFormat.EEEE("pt_BR").format(atualDate).toUpperCase().substring(0, 3)}",
                        ),
                        PersonalizedTableCell(value: Random().nextDouble() * 50000, isMoney: true),
                        PersonalizedTableCell(value: Random().nextDouble() * 3, isPercentage: true),
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
