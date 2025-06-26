import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import 'table.dart';

class DataTableItem extends StatefulWidget {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> rowValues;
  final List<double> tableColumnWidth;
  final int? columnIndexToCompareAndDetachBetterAndWorstValue;
  final double? titleMinHeight;
  final int? indexToSort;
  final List<int>? columnsIndexToSum;
  const DataTableItem({
    super.key,
    required this.titles,
    required this.rowValues,
    required this.tableColumnWidth,
    this.columnIndexToCompareAndDetachBetterAndWorstValue,
    this.titleMinHeight = 40,
    this.indexToSort,
    this.columnsIndexToSum,
  });

  @override
  State<DataTableItem> createState() => _DataTableItemState();
}

class _DataTableItemState extends State<DataTableItem> {
  bool ascending = false;
  int? _sortColumnIndex;
  List<List<PersonalizedTableCell>> sortedRows = [];
  int? minValueRowIndex;
  int? maxValueRowIndex;
  final ScrollController _footerScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAndSort();
  }

  @override
  void dispose() {
    _footerScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DataTableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only run this logic if the actual data from the parent has changed.
    if (oldWidget.rowValues != widget.rowValues) {
      setState(() {
        // Get the new data
        sortedRows = [...widget.rowValues];
        // Re-apply the sort that the user has currently selected
        _applyCurrentSort();
        _calculateMinMaxIndexes();
      });
    }
  }

  // In class _DataTableItemState

  void _applyCurrentSort() {
    // If no column is selected for sorting, do nothing.
    if (_sortColumnIndex == null) return;

    final int columnIndex = _sortColumnIndex!;
    // This is your exact sorting logic, now in a reusable function.
    sortedRows.sort((a, b) {
      final aValue = a[columnIndex].value.toString();
      final bValue = b[columnIndex].value.toString();

      final aNum = double.tryParse(aValue);
      final bNum = double.tryParse(bValue);
      if (aNum != null && bNum != null) {
        return ascending ? aNum.compareTo(bNum) : bNum.compareTo(aNum);
      }
      try {
        final aTime = _parseTime(aValue);
        final bTime = _parseTime(bValue);
        return ascending ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
      } catch (_) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }
    });
  }

  // In class _DataTableItemState

  void _initializeAndSort() {
    // Set the initial sort state from the widget properties
    _sortColumnIndex = widget.indexToSort;
    ascending = true; // Default to ascending for the first sort

    // Copy the initial data
    sortedRows = [...widget.rowValues];

    // Apply the sort and calculate highlights
    _applyCurrentSort();
    _calculateMinMaxIndexes();
  }

  // In class _DataTableItemState

  void _sortRows(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        ascending = !ascending;
      } else {
        _sortColumnIndex = columnIndex;
        ascending = true;
      }
      _applyCurrentSort(); // Use the new helper function
      _calculateMinMaxIndexes();
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

  @override
  Widget build(BuildContext context) {
    final double minWidth = widget.tableColumnWidth.reduce((p, e) => p + e);
    final screenWidth = MediaQuery.of(context).size.width;
    debugPrint("minWidth: $minWidth");
    debugPrint("screenWidth: $screenWidth");

    double availableWidth() {
      if (screenWidth > minWidth) {
        return (screenWidth - minWidth) / widget.titles.length;
      } else {
        return 0;
      }
    }

    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight - widget.titleMinHeight!,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  // Check if the notification is a scroll update and is for the horizontal axis.
                  if (notification is ScrollUpdateNotification &&
                      notification.metrics.axis == Axis.horizontal) {
                    // Command the footer's controller to jump to the same scroll position.
                    _footerScrollController.jumpTo(notification.metrics.pixels);
                  }
                  return true; // Return true to allow the notification to continue bubbling up.
                },
                child: DataTable2(
                  fixedLeftColumns: 1,
                  minWidth: screenWidth + minWidth,
                  columnSpacing: 2,
                  horizontalMargin: 2,
                  sortArrowAnimationDuration: Duration(microseconds: 0),
                  border: TableBorder.all(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                  headingRowHeight: widget.titleMinHeight,
                  headingRowColor: WidgetStateProperty.all(
                    Theme.of(context).disabledColor.withAlpha(70),
                  ),
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: ascending,
                  columns: List.generate(widget.titles.length, (index) {
                    return DataColumn2(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: widget.titles[index],
                      fixedWidth:
                          widget.tableColumnWidth[index] + availableWidth(),
                      onSort: (columnIndex, asc) => _sortRows(columnIndex),
                    );
                  }),
                  rows: [
                    ...List.generate(sortedRows.length, (rowIndex) {
                      final row = sortedRows[rowIndex];
                      final taps = row
                          .map((c) => c.onTap)
                          .whereType<VoidCallback>()
                          .toSet();
                      final unifiedTap = taps.length == 1 ? taps.first : null;

                      return DataRow2(
                        color: WidgetStateProperty.all(getColor(rowIndex)),
                        cells: List.generate(row.length, (colIndex) {
                          final cell = row[colIndex];
                          final effectiveTap = unifiedTap ?? cell.onTap;
                          return DataCell(
                            GestureDetector(
                              onTap: effectiveTap,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  children: [
                                    Expanded(child: cell),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ),
            if (widget.columnsIndexToSum?.isNotEmpty == true)
              // This is the container for your fixed footer.
              Container(
                height: widget.titleMinHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withAlpha(70),
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                // A SingleChildScrollView that is synced with the main table.
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _footerScrollController,

                  // We build the footer row using a simple Row.
                  child: Row(
                    children: List.generate(widget.titles.length, (index) {
                      // We use the exact same width calculation to ensure perfect alignment.
                      final double cellWidth =
                          widget.tableColumnWidth[index] + availableWidth();
                      final PersonalizedTableCell cell = _buildSumRow()[index];

                      return SizedBox(
                        width: cellWidth,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: index == 0 ? 0 : 0.5,
                              ),
                            ),
                          ),
                          child: cell,
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
