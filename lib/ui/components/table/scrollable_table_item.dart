import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import 'table.dart';

class ScrollableTableItem extends StatefulWidget {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> rowValues;
  final List<double>? columnsWidths;
  final int? columnIndexToCompareAndDetachBetterAndWorstValue;
  final double? titleMinHeight;
  final int? indexToSort;
  final List<int>? columnsIndexToSum;
  final bool fixFirstColumn;

  const ScrollableTableItem({
    super.key,
    required this.titles,
    required this.rowValues,
    this.columnsWidths,
    this.columnIndexToCompareAndDetachBetterAndWorstValue,
    this.titleMinHeight = 40,
    this.indexToSort,
    this.columnsIndexToSum,
    this.fixFirstColumn = false,
  });

  @override
  State<ScrollableTableItem> createState() => _ScrollableTableItemState();
}

class _ScrollableTableItemState extends State<ScrollableTableItem> {
  bool ascending = false;
  List<List<PersonalizedTableCell>> sortedRows = [];
  int? minValueRowIndex;
  int? maxValueRowIndex;

  // Vertical scroll controllers
  final ScrollController _fixedColumnScrollController = ScrollController();
  final ScrollController _scrollableColumnsScrollController =
      ScrollController();

  // Horizontal scroll controllers for header, body, and sum row
  final ScrollController _headerHorizontalController = ScrollController();
  final ScrollController _bodyHorizontalController = ScrollController();
  final ScrollController _sumHorizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAndSort();
    _setupVerticalScrollControllers();
    _setupHorizontalScrollControllers(); // Setup for horizontal sync
  }

  @override
  void didUpdateWidget(covariant ScrollableTableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rowValues != widget.rowValues ||
        oldWidget.indexToSort != widget.indexToSort) {
      _initializeAndSort();
    }
  }

  @override
  void dispose() {
    _fixedColumnScrollController.dispose();
    _scrollableColumnsScrollController.dispose();
    _headerHorizontalController.dispose();
    _bodyHorizontalController.dispose();
    _sumHorizontalController.dispose();
    super.dispose();
  }

  void _setupVerticalScrollControllers() {
    if (widget.fixFirstColumn) {
      _fixedColumnScrollController.addListener(() {
        if (_fixedColumnScrollController.position.pixels !=
            _scrollableColumnsScrollController.position.pixels) {
          _scrollableColumnsScrollController
              .jumpTo(_fixedColumnScrollController.position.pixels);
        }
      });
      _scrollableColumnsScrollController.addListener(() {
        if (_scrollableColumnsScrollController.position.pixels !=
            _fixedColumnScrollController.position.pixels) {
          _fixedColumnScrollController
              .jumpTo(_scrollableColumnsScrollController.position.pixels);
        }
      });
    }
  }

  // Method to synchronize horizontal controllers ---
  void _setupHorizontalScrollControllers() {
    // Sync Header scroll with Body and Sum
    _headerHorizontalController.addListener(() {
      _syncHorizontalScroll(_headerHorizontalController);
    });

    // Sync Body scroll with Header and Sum
    _bodyHorizontalController.addListener(() {
      _syncHorizontalScroll(_bodyHorizontalController);
    });

    // Sync Sum scroll with Header and Body
    _sumHorizontalController.addListener(() {
      _syncHorizontalScroll(_sumHorizontalController);
    });
  }

  void _syncHorizontalScroll(ScrollController primary) {
    final position = primary.position.pixels;
    if (_headerHorizontalController.hasClients &&
        _headerHorizontalController.position.pixels != position) {
      _headerHorizontalController.jumpTo(position);
    }
    if (_bodyHorizontalController.hasClients &&
        _bodyHorizontalController.position.pixels != position) {
      _bodyHorizontalController.jumpTo(position);
    }
    if (_sumHorizontalController.hasClients &&
        _sumHorizontalController.position.pixels != position) {
      _sumHorizontalController.jumpTo(position);
    }
  }

  void _initializeAndSort() {
    sortedRows = [...widget.rowValues];
    if (widget.indexToSort != null) {
      _sortRows(widget.indexToSort!);
    } else {
      _calculateMinMaxIndexes();
    }
  }

  void _sortRows(int columnIndex) {
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
    _calculateMinMaxIndexes();
  }

  void _calculateMinMaxIndexes() {
    if (widget.columnIndexToCompareAndDetachBetterAndWorstValue == null) return;
    final columnIndex =
        widget.columnIndexToCompareAndDetachBetterAndWorstValue!;
    double? minValue;
    double? maxValue;
    minValueRowIndex = null;
    maxValueRowIndex = null;
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
  }

  DateTime _parseTime(String time) {
    final cleaned = time.replaceFirst(RegExp(r'\r?\n[\s\S]*$'), '');
    final parts = cleaned.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(0, 1, 1, hour, minute);
  }

  Color getColor(int rowIndex) {
    final isDark = IsDarkTheme.isDark;
    if (rowIndex == maxValueRowIndex && sortedRows.length > 1) {
      return Colors.green.withAlpha(isDark ? 120 : 120);
    } else if (rowIndex == minValueRowIndex && sortedRows.length > 1) {
      return Colors.red.withAlpha(isDark ? 120 : 120);
    } else if (rowIndex % 2 == 0) {
      return Theme.of(context).disabledColor.withAlpha(isDark ? 40 : 30);
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
          if (row.isNotEmpty && col < row.length) {
            if (row[col].isMoney == true) isMoney = true;
            if (row[col].isPercentage == true) isPercentage = true;
          }
          final value = double.tryParse(row[col].value.toString());
          if (value != null) sum += value;
        }
        bool isInt = sum % 1 == 0;
        sumRow.add(
          PersonalizedTableCell(
            value: isPercentage == true && widget.rowValues.isNotEmpty
                ? sum / widget.rowValues.length
                : sum.toString().toBrazilianNumber(isInt ? 0 : 2),
            isTitle: true,
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
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return Colors.white;
    }
    return Platform.isIOS ? CupertinoColors.separator : Colors.black;
  }

  TableRow _buildTableRow(List<PersonalizedTableCell> cells,
      {Color? rowColor, bool isSumRow = false}) {
    final taps = cells.map((c) => c.onTap).whereType<VoidCallback>().toSet();
    VoidCallback? unifiedTap;
    if (taps.length == 1) unifiedTap = taps.first;
    final rowContent = List.generate(cells.length, (colIndex) {
      final cell = cells[colIndex];
      final effectiveTap = unifiedTap ?? cell.onTap;
      return GestureDetector(
        onTap: effectiveTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: widget.titleMinHeight ?? 1),
          child: cell,
        ),
      );
    });
    final rowChildren = rowContent.asMap().entries.map((entry) {
      final isLast = entry.key == rowContent.length - 1;
      final child = entry.value;
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(minHeight: widget.titleMinHeight ?? 1),
            child: child,
          ),
          if (isLast && taps.isNotEmpty && !isSumRow)
            Positioned(
              right: 3,
              bottom: 3,
              child: Icon(
                Platform.isIOS
                    ? CupertinoIcons.hand_point_right
                    : Icons.touch_app,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      );
    }).toList();
    return TableRow(
      children: rowChildren,
      decoration: BoxDecoration(color: rowColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PersonalizedTableCell> fixedTitles =
        widget.fixFirstColumn ? [widget.titles[0]] : [];
    final List<PersonalizedTableCell> scrollableTitles =
        widget.fixFirstColumn ? widget.titles.sublist(1) : widget.titles;

    final List<List<PersonalizedTableCell>> fixedRowValues =
        widget.fixFirstColumn ? sortedRows.map((row) => [row[0]]).toList() : [];
    final List<List<PersonalizedTableCell>> scrollableRowValues =
        widget.fixFirstColumn
            ? sortedRows.map((row) => row.sublist(1)).toList()
            : sortedRows;

    final List<PersonalizedTableCell> fullSumRow = _buildSumRow();
    final List<PersonalizedTableCell> fixedSumRow =
        widget.fixFirstColumn ? [fullSumRow[0]] : [];
    final List<PersonalizedTableCell> scrollableSumRow =
        widget.fixFirstColumn ? fullSumRow.sublist(1) : fullSumRow;

    final screenWidth = MediaQuery.of(context).size.width;
    final sumColumnsWidths = widget.columnsWidths?.reduce((p, e) => p + e);
    double availableSize() {
      if (screenWidth > sumColumnsWidths!) {
        return (screenWidth - sumColumnsWidths) /
            (widget.columnsWidths?.length ?? 1);
      }
      return 0;
    }

    final Map<int, TableColumnWidth> fixedColumnWidthsMap =
        widget.fixFirstColumn
            ? {
                0: FixedColumnWidth(widget.columnsWidths![0] + availableSize()),
              }
            : {};

    final Map<int, TableColumnWidth> scrollableColumnWidthsMap = {};
    if (widget.fixFirstColumn) {
      for (int i = 0; i < scrollableTitles.length; i++) {
        scrollableColumnWidthsMap[i] = FixedColumnWidth(
          widget.columnsWidths![i + 1] + availableSize(),
        );
      }
    } else {
      for (int i = 0; i < widget.titles.length; i++) {
        scrollableColumnWidthsMap[i] =
            widget.columnsWidths != null && i < widget.columnsWidths!.length
                ? FixedColumnWidth(widget.columnsWidths![i] + availableSize())
                : const FlexColumnWidth(1);
      }
    }

    return Expanded(
      child: Column(
        children: [
          // Header Row
          SizedBox(
            height: widget.titleMinHeight ?? 1,
            child: DefaultTextStyle(
              style: CupertinoTheme.of(context).textTheme.textStyle,
              child: Row(
                children: [
                  if (widget.fixFirstColumn)
                    Table(
                      border: TableBorder.all(
                          color: getTableBorderColor(), width: 0.06),
                      defaultColumnWidth: const FlexColumnWidth(1),
                      columnWidths: fixedColumnWidthsMap,
                      children: [
                        TableRow(
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                constraints: BoxConstraints(
                                    minHeight: widget.titleMinHeight ?? 1),
                                color: Theme.of(context)
                                    .disabledColor
                                    .withAlpha(70),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ascending = !ascending;
                                      _sortRows(0);
                                    });
                                  },
                                  child: fixedTitles[0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // --- MODIFIED: Use dedicated header controller ---
                      controller: _headerHorizontalController,
                      child: Table(
                        border: TableBorder.all(
                            color: getTableBorderColor(), width: 0.06),
                        defaultColumnWidth: const FlexColumnWidth(1),
                        columnWidths: scrollableColumnWidthsMap,
                        children: [
                          TableRow(
                            children:
                                List.generate(scrollableTitles.length, (index) {
                              final originalIndex =
                                  widget.fixFirstColumn ? index + 1 : index;
                              final tableCell = scrollableTitles[index];
                              return IntrinsicHeight(
                                child: Container(
                                  constraints: BoxConstraints(
                                      minHeight: widget.titleMinHeight ?? 1),
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withAlpha(70),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        ascending = !ascending;
                                        _sortRows(originalIndex);
                                      });
                                    },
                                    child: tableCell,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body Rows
          Flexible(
            child: Row(
              children: [
                if (widget.fixFirstColumn)
                  SingleChildScrollView(
                    controller: _fixedColumnScrollController,
                    child: DefaultTextStyle(
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                      child: Table(
                        border: TableBorder.all(
                            color: getTableBorderColor(), width: 0.06),
                        defaultColumnWidth: const FlexColumnWidth(1),
                        columnWidths: fixedColumnWidthsMap,
                        children:
                            List.generate(fixedRowValues.length, (rowIndex) {
                          return _buildTableRow(
                            fixedRowValues[rowIndex],
                            rowColor: getColor(rowIndex),
                          );
                        }),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollableColumnsScrollController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // --- MODIFIED: Use dedicated body controller ---
                      controller: _bodyHorizontalController,
                      child: DefaultTextStyle(
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                        child: Table(
                          border: TableBorder.all(
                              color: getTableBorderColor(), width: 0.06),
                          defaultColumnWidth: const FlexColumnWidth(1),
                          columnWidths: scrollableColumnWidthsMap,
                          children: List.generate(scrollableRowValues.length,
                              (rowIndex) {
                            return _buildTableRow(
                              scrollableRowValues[rowIndex],
                              rowColor: getColor(rowIndex),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sum Row
          if (widget.columnsIndexToSum != null &&
              widget.columnsIndexToSum!.isNotEmpty)
            SizedBox(
              height: widget.titleMinHeight ?? 1,
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: Row(
                  children: [
                    if (widget.fixFirstColumn)
                      Table(
                        border: TableBorder.all(
                            color: getTableBorderColor(), width: 0.06),
                        defaultColumnWidth: const FlexColumnWidth(1),
                        columnWidths: fixedColumnWidthsMap,
                        children: [
                          _buildTableRow(
                            fixedSumRow,
                            rowColor:
                                Theme.of(context).disabledColor.withAlpha(70),
                            isSumRow: true,
                          ),
                        ],
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // --- MODIFIED: Use dedicated sum row controller ---
                        controller: _sumHorizontalController,
                        child: Table(
                          border: TableBorder.all(
                              color: getTableBorderColor(), width: 0.06),
                          defaultColumnWidth: const FlexColumnWidth(1),
                          columnWidths: scrollableColumnWidthsMap,
                          children: [
                            _buildTableRow(
                              scrollableSumRow,
                              rowColor:
                                  Theme.of(context).disabledColor.withAlpha(70),
                              isSumRow: true,
                            ),
                          ],
                        ),
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
