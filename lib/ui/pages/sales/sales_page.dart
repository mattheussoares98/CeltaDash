import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectPeriodItems(
              items: [
                SelectPeriodItems.createItem(
                  title: R.string.hour,
                  onTap: () {},
                ),
                SelectPeriodItems.createItem(title: R.string.day, onTap: () {}),
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
              rowValues: [
                [
                  PersonalizedTableCell(value: "25\nseg"),
                  PersonalizedTableCell(value: 4.46),
                  PersonalizedTableCell(value: 8.81, isMoney: true),
                ],
                [
                  PersonalizedTableCell(value: "26\nter"),
                  PersonalizedTableCell(value: 9.8),
                  PersonalizedTableCell(value: 7.62, isMoney: true),
                ],
                [
                  PersonalizedTableCell(value: "27\nqua"),
                  PersonalizedTableCell(value: 14.56),
                  PersonalizedTableCell(value: 3.25, isMoney: true),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
