import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: PeriodItems()),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TableItem(
              columnWidths: {
                0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1),
              },
              titles: [
                "",
                R.string.ticketAverage,
                R.string.salesQuantity,
                R.string.averagePrice,
                R.string.productsBySale,
              ],
              values: ["1", "2", "3", "4", "5"],
            ),
          ),
        ],
      ),
    );
  }
}
