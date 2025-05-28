import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import 'table.dart';

class TableItem extends StatefulWidget {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> rowValues;
  final Map<int, TableColumnWidth>? tableColumnWidth;
  final int? columnIndexToCompareAndDetachBetterAndWorstValue;
  final double? titleMinHeight;
  final int? indexToSort;
  final List<int>? columnsIndexToSum;
  const TableItem({
    super.key,
    required this.titles,
    required this.rowValues,
    this.tableColumnWidth,
    this.columnIndexToCompareAndDetachBetterAndWorstValue,
    this.titleMinHeight,
    this.indexToSort,
    this.columnsIndexToSum,
  });

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  bool ascending = false;
  List<List<PersonalizedTableCell>> sortedRows = [];
  int? minValueRowIndex;
  int? maxValueRowIndex;

  @override
  void initState() {
    super.initState();
    _initializeAndSort();
  }

  @override
  void didUpdateWidget(covariant TableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-init if the data or sort-column actually changed
    if (oldWidget.rowValues != widget.rowValues ||
        oldWidget.indexToSort != widget.indexToSort) {
      _initializeAndSort();
    }
  }

  void _initializeAndSort() {
    // Copy the incoming rows
    sortedRows = [...widget.rowValues];

    // Apply the initial sort
    if (widget.indexToSort != null) {
      _sortRows(widget.indexToSort!);
    } else {
      // still highlight best/worst even if no sort
      _calculateMinMaxIndexes();
    }
  }

  void _sortRows(int columnIndex) {
    sortedRows.sort((a, b) {
      final aValue = a[columnIndex].value.toString();
      final bValue = b[columnIndex].value.toString();

      // Try numeric
      final aNum = double.tryParse(aValue);
      final bNum = double.tryParse(bValue);
      if (aNum != null && bNum != null) {
        return ascending ? aNum.compareTo(bNum) : bNum.compareTo(aNum);
      }

      // Try time HH:mm
      try {
        final aTime = _parseTime(aValue);
        final bTime = _parseTime(bValue);
        return ascending ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
      } catch (_) {
        // Fallback to string
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }
    });
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
    // setState(() {});
  }

  DateTime _parseTime(String time) {
    // strip off the first line‐break (LF or CRLF) and everything after it
    final cleaned = time.replaceFirst(RegExp(r'\r?\n[\s\S]*$'), '');

    // now split on “:”
    final parts = cleaned.split(':');
    final hour = int.parse(parts[0]);

    // if there’s no minute part (e.g. “10”), default to 0
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;

    return DateTime(0, 1, 1, hour, minute);
  }

  Color getColor(int rowIndex) {
    if (rowIndex == maxValueRowIndex && widget.rowValues.length > 1) {
      return Colors.green.withAlpha(120);
    } else if (rowIndex == minValueRowIndex && widget.rowValues.length > 1) {
      return Colors.red.withAlpha(120);
    } else if (rowIndex % 2 == 0) {
      return Theme.of(context).disabledColor.withAlpha(30);
    }
    return Colors.transparent;
  }

  List<PersonalizedTableCell> _buildSumRow() {
    List<PersonalizedTableCell> sumRow = [];

    for (int col = 0; col < widget.titles.length; col++) {
      bool isMoney = false;
      bool isPercentage = false;

      if (widget.columnsIndexToSum?.contains(col) == true) {
        double sum = 0.0;
        for (var row in sortedRows) {
          if (row[col].isMoney == true) {
            isMoney = true;
          }
          if (row[col].isPercentage == true) {
            isPercentage = true;
          }

          final value = double.tryParse(row[col].value.toString());
          if (value != null) {
            sum += value;
          }
        }

        bool isInt = sum % 1 == 0;
        sumRow.add(
          PersonalizedTableCell(
            value: isPercentage == true
                ? sum / widget.rowValues.length
                : sum.toString().toBrazilianNumber(isInt ? 0 : 2),
            isTitle: true, // Style it like a header cell
            isMoney: isMoney,
            isPercentage: isPercentage,
          ),
        );
      } else {
        sumRow.add(PersonalizedTableCell(value: '', isTitle: true));
      }
    }

    return sumRow;
  }

  Color getTableBorderColor() {
    return Platform.isIOS ? CupertinoColors.separator : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: widget.titleMinHeight ?? 1,
            child: DefaultTextStyle(
              style: CupertinoTheme.of(context).textTheme.textStyle,
              child: Table(
                border:
                    TableBorder.all(color: getTableBorderColor(), width: 0.06),
                defaultColumnWidth: FlexColumnWidth(1),
                columnWidths: widget
                    .tableColumnWidth /* ??
                    {0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)} */
                ,
                children: [
                  TableRow(
                    children: List.generate(widget.titles.length, (index) {
                      final tableCell = widget.titles[index];
                      return IntrinsicHeight(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: widget.titleMinHeight ?? 1,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ascending = !ascending;
                                _sortRows(index);
                              });
                            },
                            child: Container(
                              color: CupertinoColors.systemGrey6,
                              child: PersonalizedTableCell(
                                value: tableCell.value,
                                isTitle: true,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: Table(
                  border: TableBorder.all(
                    color: getTableBorderColor(),
                    width: 0.06,
                  ),
                  defaultColumnWidth: FlexColumnWidth(1),
                  columnWidths: widget
                      .tableColumnWidth /* ??
                      {0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)} */
                  ,
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
                        decoration: BoxDecoration(
                          color: getColor(index),
                          // borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.columnsIndexToSum != null &&
              widget.columnsIndexToSum!.isNotEmpty)
            SizedBox(
              height: widget.titleMinHeight ?? 1,
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: Table(
                  border: TableBorder.all(
                      color: getTableBorderColor(), width: 0.06),
                  defaultColumnWidth: FlexColumnWidth(1),
                  columnWidths: widget.tableColumnWidth,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withAlpha(70),
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      children: _buildSumRow()
                          .map((e) => IntrinsicHeight(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: widget.titleMinHeight ?? 1,
                                  ),
                                  child: e,
                                ),
                              ))
                          .toList(),
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
