import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Assuming these are your custom imports.
// You may need to adjust the paths if they are incorrect.
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';
import '../../pages/pages.dart';
import 'mixin/mixin.dart';
import 'table.dart';

class ScrollableTableItem extends StatefulWidget {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> rowValues;
  final List<double> columnsWidths;
  final int? columnIndexToCompareAndDetachBetterAndWorstValue;
  final double titleMinHeight;
  final int? indexToSort;
  final List<int>? columnsIndexToSum;
  final bool fixFirstColumn;
  final bool showAnimation;
  final void Function() hideShowAnimation;
  final int animationSecondsDuration;
  final String pdfFileName;
  final PeriodType? selectedPeriodType;
  final GetSaleStatisticsParams? getSalesStatisticsParams;

  const ScrollableTableItem({
    super.key,
    required this.titles,
    required this.rowValues,
    required this.columnsWidths,
    required this.showAnimation,
    required this.hideShowAnimation,
    required this.pdfFileName,
    this.getSalesStatisticsParams,
    this.selectedPeriodType,
    this.animationSecondsDuration = 2,
    this.columnIndexToCompareAndDetachBetterAndWorstValue,
    this.titleMinHeight = 40,
    this.indexToSort,
    this.columnsIndexToSum,
    this.fixFirstColumn = false,
  });

  @override
  State<ScrollableTableItem> createState() => _ScrollableTableItemState();
}

class _ScrollableTableItemState extends State<ScrollableTableItem>
    with HelpersMixin {
  late List<List<PersonalizedTableCell>> _sortedRows;
  int? _currentSortColumn;
  bool _isAscending = false;
  bool alreadyShowedAnimation = false;

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
    _resetDataAndSort();
    _setupVerticalScrollControllers();
    _setupHorizontalScrollControllers();
  }

  @override
  void didUpdateWidget(covariant ScrollableTableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This prevents the sort order from being reset on every hot reload.
    if (widget.rowValues != oldWidget.rowValues) {
      setState(() {
        _sortedRows = [...widget.rowValues]; // Update the data
        _sortRows(); // Re-apply the existing sort, not the initial one
      });
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

  void _resetDataAndSort() {
    setState(() {
      _sortedRows = [...widget.rowValues];
      _currentSortColumn = widget.indexToSort;
      _isAscending = false; // Default sort direction

      if (_currentSortColumn != null) {
        _sortRows();
      } else {
        _calculateMinMaxIndexes();
      }
    });
  }

  void _handleHeaderTap(int columnIndex) {
    setState(() {
      if (_currentSortColumn == columnIndex) {
        // If tapping the same column, reverse the sort direction
        _isAscending = !_isAscending;
      } else {
        // If tapping a new column, set it and use the default direction
        _currentSortColumn = columnIndex;
        _isAscending = false;
      }
      _sortRows();
    });
  }

  void _sortRows() {
    if (_currentSortColumn == null) {
      _calculateMinMaxIndexes();
      return;
    }

    final int columnIndex = _currentSortColumn!;

    _sortedRows.sort((a, b) {
      final aValue = a[columnIndex].value.toString();
      final bValue = b[columnIndex].value.toString();
      final aSplit = aValue.toString().split(' ').first.padLeft(2, "0");
      final bSplit = bValue.toString().split(' ').first.padLeft(2, "0");
      final aNum = double.tryParse(aSplit);
      final bNum = double.tryParse(bSplit);

      if (aNum != null && bNum != null) {
        return _isAscending ? aNum.compareTo(bNum) : bNum.compareTo(aNum);
      }

      final aInt = int.tryParse(aValue.split(':').first);
      final bInt = int.tryParse(bValue.split(':').first);
      if (aInt != null && bInt != null) {
        return _isAscending ? aInt.compareTo(bInt) : bInt.compareTo(aInt);
      }
      try {
        final aTime = parseTime(aValue);
        final bTime = parseTime(bValue);
        // Assuming time comparison logic might be different
        return _isAscending ? aTime.compareTo(bTime) : bTime.compareTo(aTime);
      } catch (_) {
        return _isAscending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      }
    });

    _calculateMinMaxIndexes();
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

  void _setupHorizontalScrollControllers() {
    _headerHorizontalController.addListener(() {
      _syncHorizontalScroll(_headerHorizontalController);
    });
    _bodyHorizontalController.addListener(() {
      _syncHorizontalScroll(_bodyHorizontalController);
    });
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

  void _calculateMinMaxIndexes() {
    if (widget.columnIndexToCompareAndDetachBetterAndWorstValue == null) return;
    final columnIndex =
        widget.columnIndexToCompareAndDetachBetterAndWorstValue!;
    double? minValue;
    double? maxValue;
    minValueRowIndex = null;
    maxValueRowIndex = null;
    for (int i = 0; i < _sortedRows.length; i++) {
      final value = double.tryParse(
        _sortedRows[i][columnIndex].value.toString(),
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

  Color getColor(int rowIndex) {
    if (rowIndex == maxValueRowIndex && _sortedRows.length > 1) {
      return Colors.green.withAlpha(120);
    } else if (rowIndex == minValueRowIndex && _sortedRows.length > 1) {
      return Colors.red.withAlpha(120);
    } else if (_sortedRows.isNotEmpty &&
        _sortedRows[rowIndex].first.decoration != null) {
      return _sortedRows[rowIndex].first.decoration?.color ??
          Colors.transparent;
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
        for (var row in _sortedRows) {
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
        sumRow.add(const PersonalizedTableCell(value: '', isTitle: true));
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

  Future<void> _openPdfPage() async {
    if (_sortedRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There is no data to export.")),
      );
      return;
    }

    // 1. Instantiate the generator as before.
    final pdfGenerator = SaleStatisticPdfGenerator(
      pdfFileName: widget.pdfFileName, // Title in Portuguese
      titles: widget.titles,
      sortedRows: _sortedRows,
      columnsWidths: widget.columnsWidths,
      sumRow: (widget.columnsIndexToSum?.isNotEmpty ?? false)
          ? _buildSumRow()
          : null,
      minValueRowIndex: minValueRowIndex,
      maxValueRowIndex: maxValueRowIndex,
      getSalesStatisticsParams: widget.getSalesStatisticsParams,
    );

    // 2. Get the Future that will generate the PDF bytes, but DO NOT await it here.
    final bytes = await pdfGenerator.generatePdfBytes();

    // 3. Navigate to the new viewer page, passing the Future to it.
    // The FutureBuilder inside PdfViewerPage will handle waiting for the result.
    if (mounted) {
      PdfViewerPage.openPdf(bytes, widget.pdfFileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedRows.isEmpty && widget.rowValues.isNotEmpty) {
      // This can act as a fallback if the state somehow isn't initialized yet.
      _resetDataAndSort();
    }

    final List<PersonalizedTableCell> fixedTitles =
        widget.fixFirstColumn ? [widget.titles[0]] : [];
    final List<PersonalizedTableCell> scrollableTitles =
        widget.fixFirstColumn ? widget.titles.sublist(1) : widget.titles;

    // NEW, SIMPLIFIED LOGIC
    final List<List<PersonalizedTableCell>> fixedRowValues =
        widget.fixFirstColumn
            ? _sortedRows.map((row) => [row[0]]).toList()
            : [];

    final List<List<PersonalizedTableCell>> scrollableRowValues =
        widget.fixFirstColumn
            ? _sortedRows.map((row) => row.sublist(1)).toList()
            : _sortedRows;

    final List<PersonalizedTableCell> fullSumRow = _buildSumRow();
    final List<PersonalizedTableCell> fixedSumRow =
        widget.fixFirstColumn ? [fullSumRow[0]] : [];
    final List<PersonalizedTableCell> scrollableSumRow =
        widget.fixFirstColumn ? fullSumRow.sublist(1) : fullSumRow;

    final screenWidth = MediaQuery.of(context).size.width;
    final sumColumnsWidths = widget.columnsWidths.reduce((p, e) => p + e);

    final availableSize = screenWidth > sumColumnsWidths
        ? (screenWidth - sumColumnsWidths) / (widget.columnsWidths.length)
        : 0.0;

    final Map<int, TableColumnWidth> scrollableColumnWidthsMap = {};
    if (widget.fixFirstColumn) {
      for (int i = 0; i < scrollableTitles.length; i++) {
        scrollableColumnWidthsMap[i] =
            FixedColumnWidth(widget.columnsWidths[i + 1] + availableSize);
      }
    } else {
      for (int i = 0; i < widget.titles.length; i++) {
        scrollableColumnWidthsMap[i] =
            FixedColumnWidth(widget.columnsWidths[i] + availableSize);
      }
    }

    if (widget.titles.where((e) => e.isTitle != true).isNotEmpty) {
      return const Text("Some titles are not defined as title");
    }

    final materialTheme = Theme.of(context);
    final cupertinoTextStyle = CupertinoTheme.of(context).textTheme.textStyle;
    final disabledColor = materialTheme.disabledColor.withAlpha(70);

    return Expanded(
      child: Column(
        children: [
          // Header Row
          SizedBox(
            height: widget.titleMinHeight,
            child: DefaultTextStyle(
              style: cupertinoTextStyle,
              child: Stack(
                children: [
                  Row(
                    children: [
                      if (widget.fixFirstColumn)
                        Table(
                          border: TableBorder.all(
                              color: getTableBorderColor(), width: 0.06),
                          defaultColumnWidth: const FlexColumnWidth(1),
                          columnWidths: {
                            0: FixedColumnWidth(
                                widget.columnsWidths[0] + availableSize)
                          },
                          children: [
                            TableRow(
                              children: [
                                IntrinsicHeight(
                                  child: InkWell(
                                    onTap: () => _handleHeaderTap(0),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minHeight: widget.titleMinHeight),
                                      decoration: BoxDecoration(
                                        border: borderDecoration,
                                        color: disabledColor,
                                      ),
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
                          controller: _headerHorizontalController,
                          physics: const ClampingScrollPhysics(),
                          child: Table(
                            border: TableBorder.all(
                                color: getTableBorderColor(), width: 0.06),
                            defaultColumnWidth: const FlexColumnWidth(1),
                            columnWidths: scrollableColumnWidthsMap,
                            children: [
                              TableRow(
                                children: List.generate(scrollableTitles.length,
                                    (index) {
                                  final originalIndex =
                                      widget.fixFirstColumn ? index + 1 : index;
                                  final tableCell = scrollableTitles[index];
                                  return IntrinsicHeight(
                                    child: InkWell(
                                      onTap: () =>
                                          _handleHeaderTap(originalIndex),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minHeight: widget.titleMinHeight,
                                        ),
                                        decoration: BoxDecoration(
                                          border: borderDecoration,
                                          color: disabledColor,
                                        ),
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
                  Positioned(
                    left: 0,
                    top: 0,
                    child: InkWell(
                      onTap: _openPdfPage,
                      child: const Icon(Icons.picture_as_pdf_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body Rows
          Flexible(
            child: Stack(
              children: [
                Row(
                  children: [
                    if (widget.fixFirstColumn)
                      SingleChildScrollView(
                        controller: _fixedColumnScrollController,
                        child: DefaultTextStyle(
                          style: cupertinoTextStyle,
                          child: Table(
                            border: TableBorder.all(
                                color: getTableBorderColor(), width: 0.06),
                            defaultColumnWidth: const FlexColumnWidth(1),
                            columnWidths: {
                              0: FixedColumnWidth(
                                  widget.columnsWidths[0] + availableSize)
                            },
                            children: List.generate(fixedRowValues.length,
                                (rowIndex) {
                              final fullRow = _sortedRows[rowIndex];
                              final tapsInRow = fullRow
                                  .map((c) => c.onTap)
                                  .whereType<VoidCallback>()
                                  .toSet();
                              final isUnifiedTapRow = tapsInRow.length == 1;
                              final unifiedTap =
                                  isUnifiedTapRow ? tapsInRow.first : null;

                              return buildTableRow(
                                fixedRowValues[rowIndex],
                                rowColor: getColor(rowIndex),
                                isSumRow: false,
                                isUnifiedTapRow: isUnifiedTapRow,
                                unifiedTap: unifiedTap,
                                startingColumnIndex: 0,
                                context: context,
                                titleMinHeight: widget.titleMinHeight,
                              );
                            }),
                          ),
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollableColumnsScrollController,
                        physics: const ClampingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _bodyHorizontalController,
                          physics: const ClampingScrollPhysics(),
                          child: DefaultTextStyle(
                            style: cupertinoTextStyle,
                            child: Table(
                              border: TableBorder.all(
                                  color: getTableBorderColor(), width: 0.06),
                              defaultColumnWidth: const FlexColumnWidth(1),
                              columnWidths: scrollableColumnWidthsMap,
                              children: List.generate(
                                  scrollableRowValues.length, (rowIndex) {
                                final fullRow = _sortedRows[rowIndex];
                                final tapsInRow = fullRow
                                    .map((c) => c.onTap)
                                    .whereType<VoidCallback>()
                                    .toSet();
                                final isUnifiedTapRow = tapsInRow.length == 1;
                                final unifiedTap =
                                    isUnifiedTapRow ? tapsInRow.first : null;

                                return buildTableRow(
                                  scrollableRowValues[rowIndex],
                                  rowColor: getColor(rowIndex),
                                  isSumRow: false,
                                  isUnifiedTapRow: isUnifiedTapRow,
                                  unifiedTap: unifiedTap,
                                  startingColumnIndex:
                                      widget.fixFirstColumn ? 1 : 0,
                                  context: context,
                                  titleMinHeight: widget.titleMinHeight,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (availableSize == 0 &&
                    widget.showAnimation &&
                    !alreadyShowedAnimation)
                  Builder(builder: (context) {
                    final animationDuration = Duration(
                        seconds: (widget.animationSecondsDuration / 2).toInt());

                    if (_bodyHorizontalController.hasClients) {
                      _bodyHorizontalController.animateTo(
                        curve: Curves.linear,
                        duration: animationDuration,
                        widget.columnsWidths.reduce((p, e) => p + e),
                      );
                    }
                    Future.delayed(animationDuration, () async {
                      if (_bodyHorizontalController.hasClients) {
                        await _bodyHorizontalController.animateTo(
                          curve: Curves.linear,
                          duration: animationDuration,
                          0,
                        );
                        if (mounted) {
                          setState(() {
                            alreadyShowedAnimation = true;
                          });
                        }
                      }
                    });

                    widget.hideShowAnimation();

                    return Positioned(
                      bottom: 0,
                      top: 0,
                      left: widget.columnsWidths.first,
                      child: const HorizontalScrollableIndicator(),
                    );
                  }),
              ],
            ),
          ),
          // Sum Row
          if (widget.columnsIndexToSum != null &&
              widget.columnsIndexToSum!.isNotEmpty)
            SizedBox(
              height: widget.titleMinHeight,
              child: DefaultTextStyle(
                style: cupertinoTextStyle,
                child: Row(
                  children: [
                    if (widget.fixFirstColumn)
                      Table(
                        border: TableBorder.all(
                            color: getTableBorderColor(), width: 0.06),
                        defaultColumnWidth: const FlexColumnWidth(1),
                        columnWidths: {
                          0: FixedColumnWidth(
                              widget.columnsWidths[0] + availableSize)
                        },
                        children: [
                          buildTableRow(
                            fixedSumRow,
                            rowColor: disabledColor,
                            isSumRow: true,
                            isUnifiedTapRow: false, // Sum row is not tappable
                            unifiedTap: null,
                            startingColumnIndex: 0, context: context,
                            titleMinHeight: widget.titleMinHeight,
                          ),
                        ],
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _sumHorizontalController,
                        physics: const ClampingScrollPhysics(),
                        child: Table(
                          border: TableBorder.all(
                              color: getTableBorderColor(), width: 0.06),
                          defaultColumnWidth: const FlexColumnWidth(1),
                          columnWidths: scrollableColumnWidthsMap,
                          children: [
                            buildTableRow(
                              scrollableSumRow,
                              rowColor: disabledColor,
                              isSumRow: true,
                              isUnifiedTapRow: false, // Sum row is not tappable
                              unifiedTap: null,
                              startingColumnIndex:
                                  widget.fixFirstColumn ? 1 : 0,
                              context: context,
                              titleMinHeight: widget.titleMinHeight,
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
