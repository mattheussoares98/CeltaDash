import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectPeriodItems(
              items: [
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
                R.string.ticketAverage.toUpperCase(),
                R.string.salesQuantityAbbreviated.toUpperCase(),
                R.string.productsBySale.toUpperCase(),
                R.string.averagePrice.toUpperCase(),
              ],
              rowValues: [
                [
                  PersonalizedTableCell(value: "25\nseg"),
                  PersonalizedTableCell(value: 39.19, isMoney: true),
                  PersonalizedTableCell(value: 215),
                  PersonalizedTableCell(value: 4.46),
                  PersonalizedTableCell(value: 8.81, isMoney: true),
                ],
                [
                  PersonalizedTableCell(value: "26\nter"),
                  PersonalizedTableCell(value: 25.80, isMoney: true),
                  PersonalizedTableCell(value: 115),
                  PersonalizedTableCell(value: 9.8),
                  PersonalizedTableCell(value: 7.62, isMoney: true),
                ],
                [
                  PersonalizedTableCell(value: "27\nqua"),
                  PersonalizedTableCell(value: 68.80, isMoney: true),
                  PersonalizedTableCell(value: 86),
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
