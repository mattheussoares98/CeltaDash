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
  int? orderByIndex;
  bool ascending = true;
  List<List<PersonalizedTableCell>> sortedRows = [];
  int? minValueRowIndex;
  int? maxValueRowIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the input data changed, and reset state
    debugPrint("updated");
    sortedRows = [...widget.rowValues];
    _calculateMinMaxIndexes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.indexToSort != null) {
        sortTable(widget.indexToSort!);
        sortTable(widget.indexToSort!);
      }
    });
  }

  @override
  void didUpdateWidget(covariant TableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    sortedRows = [...oldWidget.rowValues];
    _calculateMinMaxIndexes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && oldWidget.indexToSort != null) {
        sortTable(oldWidget.indexToSort!);
        sortTable(oldWidget.indexToSort!);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              border: TableBorder.all(color: Colors.black, width: 0.06),
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
                        child: InkWell(
                          onTap: () => sortTable(index),
                          child: PersonalizedTableCell(
                            value: tableCell.value,
                            isTitle: true,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: Colors.black, width: 0.06),
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
                      decoration: BoxDecoration(color: getColor(index)),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.columnsIndexToSum != null &&
                widget.columnsIndexToSum!.isNotEmpty)
              Table(
                border: TableBorder.all(color: Colors.black, width: 0.06),
                defaultColumnWidth: FlexColumnWidth(1),
                columnWidths: widget.tableColumnWidth,
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: _buildSumRow(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
