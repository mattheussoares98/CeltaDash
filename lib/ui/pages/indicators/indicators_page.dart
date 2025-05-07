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
        onChangeEnterprise: (_) {
          debugPrint("Search indicators again");
        },
      ),
      body: Column(
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
          TableItem(
            tableColumnWidth: {
              0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.13),
            },
            columnIndexToCompareAndDetachBetterAndWorstValue: 1,
            titleMinHeight: 43,
            titles: [
              PersonalizedTableCell(value: R.string.day.toUpperCase()),
              PersonalizedTableCell(
                value: R.string.ticketAverage.toUpperCase(),
              ),
              PersonalizedTableCell(
                value: R.string.salesQuantityAbbreviated.toUpperCase(),
              ),
              PersonalizedTableCell(
                value: R.string.productsBySale.toUpperCase(),
              ),
              PersonalizedTableCell(
                value: R.string.averagePrice.toUpperCase(),
              ),
            ],
            rowValues: List.generate(DateTime.now().day, (index) {
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
            }).toList().reversed.toList(),
          ),
        ],
      ),
    );
  }
}
