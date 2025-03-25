import 'package:flutter/material.dart';

import 'table.dart';

class TableItem extends StatefulWidget {
  final List<String> titles;
  final List<List<PersonalizedTableCell>> rowValues;
  final Map<int, TableColumnWidth>? columnWidths;
  const TableItem({
    super.key,
    required this.titles,
    required this.rowValues,
    this.columnWidths,
  });

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  int? orderByIndex;
  bool ascending = true;
  List<List<PersonalizedTableCell>> sortedRows = [];

  @override
  initState() {
    super.initState();
    sortedRows = [...widget.rowValues];
  }

  void sortTable(int columnIndex) {
    setState(() {
      if (orderByIndex == columnIndex) {
        ascending = !ascending;
      } else {
        ascending = true;
        orderByIndex = columnIndex;
      }

      sortedRows.sort((a, b) {
        final aValue = a[columnIndex].value.toString();
        final bValue = b[columnIndex].value.toString();
        if (double.tryParse(aValue) != null &&
            double.tryParse(bValue) != null) {
          return ascending
              ? double.parse(aValue).compareTo(double.parse(bValue))
              : double.parse(bValue).compareTo(double.parse(aValue));
        }
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.06),
      defaultColumnWidth: FlexColumnWidth(1),
      columnWidths: widget.columnWidths /* ??
          {0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)} */,
      children: [
        TableRow(
          children: List.generate(widget.titles.length, (index) {
            return PersonalizedTableCell(
              value: widget.titles[index],
              onTap: () => sortTable(index),
            );
          }),
        ),
        ...List.generate(
          sortedRows.length,
          (index) => TableRow(
            children: sortedRows[index],
            decoration: BoxDecoration(
              color:
                  index % 2 == 1
                      ? Theme.of(context).primaryColorLight.withAlpha(15)
                      : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
