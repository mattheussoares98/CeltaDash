import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
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
                    title:
                        "200+ ${DateFormat.MMMd("pt_BR").format(DateTime.now())}",
                    onTap: () {},
                  ),
                  SelectPeriodItems.createItem(
                    title:
                        "200+ ${DateFormat.MMMd("pt_BR").format(DateTime.now().subtract(Duration(days: 1)))}",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TableItem(
                tableColumnWidth: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.18),
                },
                columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                titles: [
                  R.string.positionAbbreviated.toUpperCase(),
                  R.string.product.toUpperCase(),
                  "${R.string.totalSales.toUpperCase()} (R\$)",
                  R.string.quantityAbbreviated.toUpperCase(),
                  "${R.string.averagePrice.toUpperCase()} (R\$)",
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
                      final quantity =
                          Random().nextInt(100) * Random().nextDouble();

                      return [
                        PersonalizedTableCell(
                          value: atualDate.day,
                          subtile: DateFormat.EEEE(
                            "pt_BR",
                          ).format(atualDate).toUpperCase().substring(0, 3),
                        ),
                        PersonalizedTableCell(value: faker.food.cuisine()),
                        PersonalizedTableCell(value: totalSales),
                        PersonalizedTableCell(value: quantity),
                        PersonalizedTableCell(value: (totalSales / quantity)),
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
