import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: () {
          debugPrint("Search indicators again");
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
                  R.string.ticketAverage.toUpperCase(),
                  R.string.salesQuantityAbbreviated.toUpperCase(),
                  R.string.productsBySale.toUpperCase(),
                  R.string.averagePrice.toUpperCase(),
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
                      final quantitySales = Random().nextInt(999);
                      final int productsBySale = Random().nextInt(11) + 4;

                      return [
                        PersonalizedTableCell(
                          value: atualDate.day,
                          subtile: DateFormat.EEEE(
                            "pt_BR",
                          ).format(atualDate).toUpperCase().substring(0, 3),
                        ),
                        PersonalizedTableCell(
                          value: totalSales / quantitySales,
                          isMoney: true,
                        ),
                        PersonalizedTableCell(value: quantitySales),
                        PersonalizedTableCell(value: productsBySale),
                        PersonalizedTableCell(
                          value: totalSales / productsBySale / quantitySales,
                          isMoney: true,
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
