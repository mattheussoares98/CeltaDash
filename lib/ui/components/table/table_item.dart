import 'package:flutter/material.dart';

import 'table.dart';

class TableItem extends StatelessWidget {
  final List<String> titles;
  final List<String> values;
  final Map<int, TableColumnWidth>? columnWidths;
  const TableItem({
    super.key,
    required this.titles,
    required this.values,
    this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.1),
      defaultColumnWidth: FlexColumnWidth(1),
      columnWidths:
          columnWidths ??
          {0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)},
      children: [
        TableRow(
          children: titles.map((e) => PersonalizedTableCell(name: e)).toList(),
        ),
        TableRow(
          children: values.map((e) => PersonalizedTableCell(name: e)).toList(),
        ),
      ],
    );
  }
}
