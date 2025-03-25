import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class TableItem extends StatelessWidget {
  const TableItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.1),
      defaultColumnWidth: FlexColumnWidth(1),
      columnWidths: {
        0: FixedColumnWidth(MediaQuery.of(context).size.width / 8 - 2),
      },
      children: [
        TableRow(
          children: [
            _PersonalizedTableCell(name: ""),
            _PersonalizedTableCell(name: R.string.ticketAverage.toUpperCase()),

            _PersonalizedTableCell(
              name: R.string.salesQuantityAbbreviated.toUpperCase(),
            ),
            _PersonalizedTableCell(name: R.string.averagePrice.toUpperCase()),
            _PersonalizedTableCell(name: R.string.productsBySale.toUpperCase()),
          ],
        ),
        TableRow(
          children: [
            _PersonalizedTableCell(name: "1"),
            _PersonalizedTableCell(name: "2"),
            _PersonalizedTableCell(name: "3"),
            _PersonalizedTableCell(name: "4"),
            _PersonalizedTableCell(name: "5"),
          ],
        ),
      ],
    );
  }
}

class _PersonalizedTableCell extends StatelessWidget {
  final String name;
  const _PersonalizedTableCell({required this.name});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
