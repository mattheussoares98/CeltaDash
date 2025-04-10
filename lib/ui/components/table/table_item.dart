import 'package:flutter/material.dart';

import 'table.dart';

class TableItem extends StatefulWidget {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> rowValues;
  final Map<int, TableColumnWidth>? tableColumnWidth;
  final int? columnIndexToCompareAndDetachBetterAndWorstValue;
  final double? titleMinHeight;
  const TableItem({
    super.key,
    required this.titles,
    required this.rowValues,
    this.tableColumnWidth,
    this.columnIndexToCompareAndDetachBetterAndWorstValue,
    this.titleMinHeight,
  });

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  int? orderByIndex;
  bool ascending = true;
  List<List<PersonalizedTableCell>> sortedRows = [];
  int? minValueRowIndex;
  int? maxValueRowIndex;

  @override
  initState() {
    super.initState();
    sortedRows = [...widget.rowValues];
    _calculateMinMaxIndexes();
  }

  void _calculateMinMaxIndexes() {
    if (widget.columnIndexToCompareAndDetachBetterAndWorstValue == null) return;
    final columnIndex =
        widget.columnIndexToCompareAndDetachBetterAndWorstValue!;

    double? minValue;
    double? maxValue;

    for (int i = 0; i < sortedRows.length; i++) {
      final value = double.tryParse(
        sortedRows[i][columnIndex].value.toString(),
      );
      if (value != null) {
        if (minValue == null || value < minValue) {
          minValue = value;
          minValueRowIndex = i;
        }
        if (maxValue == null || value > maxValue) {
          maxValue = value;
          maxValueRowIndex = i;
        }
      }
    }
    setState(() {});
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
    _calculateMinMaxIndexes();
  }

  Color getColor(int rowIndex) {
    if (rowIndex == minValueRowIndex) return Colors.red.withAlpha(120);
    if (rowIndex == maxValueRowIndex) return Colors.green.withAlpha(120);
    if (rowIndex % 2 == 0) {
      return Theme.of(context).primaryColorLight.withAlpha(20);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Table(
            border: TableBorder.all(color: Colors.black, width: 0.06),
            defaultColumnWidth: FlexColumnWidth(1),
            columnWidths: widget.tableColumnWidth /* ??
                {0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)} */,
            children: [
              TableRow(
                children: List.generate(widget.titles.length, (index) {
                  return IntrinsicHeight(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: widget.titleMinHeight ?? 1,
                      ),
                      child: InkWell(
                        onTap: () => sortTable(index),
                        child: widget.titles[index],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: Colors.black, width: 0.06),
                defaultColumnWidth: FlexColumnWidth(1),
                columnWidths: widget.tableColumnWidth /* ??
                    {0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)} */,
                children: [
                  ...List.generate(
                    sortedRows.length,
                    //travel a list of PersonalizedTableCell
                    (index) => TableRow(
                      children: List.generate(
                        sortedRows[index].length,
                        //get each PersonalizedTableCell to insert IntrinsicHeight and center the value
                        (i) {
                          return IntrinsicHeight(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: widget.titleMinHeight ?? 1,
                              ),
                              child: sortedRows[index][i],
                            ),
                          );
                        },
                      ),
                      decoration: BoxDecoration(color: getColor(index)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
