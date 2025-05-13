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
  final rows = List.generate(DateTime.now().day, (_) {
    final totalSales = Random().nextDouble() * 50000;
    final quantity = Random().nextInt(100) * Random().nextDouble();
    final Map<String, dynamic> row = {
      'totalSales': totalSales,
      'quantity': quantity,
      'product': faker.food.cuisine(),
    };
    return row;
  }).toList();

  @override
  Widget build(BuildContext context) {
    rows.sort((a, b) => a['totalSales']!.compareTo(b['totalSales']!));

    return Scaffold(
      body: Column(
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
          TableItem(
            titleMinHeight: 43,
            tableColumnWidth: {
              0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
              3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.18),
            },
            columnIndexToCompareAndDetachBetterAndWorstValue: 2,
            titles: [
              PersonalizedTableCell(
                value: R.string.positionAbbreviated.toUpperCase(),
              ),
              PersonalizedTableCell(value: R.string.product.toUpperCase()),
              PersonalizedTableCell(value: R.string.totalSales.toUpperCase()),
              PersonalizedTableCell(
                value: R.string.quantityAbbreviated.toUpperCase(),
              ),
              PersonalizedTableCell(value: R.string.averagePrice.toUpperCase()),
            ],
            rowValues: rows.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final totalSales = item['totalSales']!;
              final quantity = item['quantity']!;

              return [
                PersonalizedTableCell(value: index + 1),
                PersonalizedTableCell(value: item['product']),
                PersonalizedTableCell(value: totalSales, isMoney: true),
                PersonalizedTableCell(value: quantity),
                PersonalizedTableCell(
                  value: totalSales / quantity,
                  isMoney: true,
                ),
              ];
            }).toList(),
          ),
        ],
      ),
    );
  }
}
