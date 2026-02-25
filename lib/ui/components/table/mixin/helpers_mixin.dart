import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../pages/pages.dart';
import '../../components.dart';

mixin HelpersMixin on State<ScrollableTableItem> {
  final borderDecoration = const BorderDirectional(
    end: BorderSide(
      width: 0.5,
      color: Colors.white,
    ),
  );

  DateTime parseTime(String time) {
    final cleaned = time.replaceFirst(RegExp(r'\r?\n[\s\S]*$'), '');
    final parts = cleaned.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(0, 1, 1, hour, minute);
  }

  TableRow buildTableRow(
    List<PersonalizedTableCell> cells, {
    required Color? rowColor,
    required bool isSumRow,
    required bool isUnifiedTapRow,
    required VoidCallback? unifiedTap,
    required int startingColumnIndex,
    required BuildContext context,
  }) {
    final rowChildren = List.generate(cells.length, (colIndex) {
      final cell = cells[colIndex];
      // The cell's absolute position in the original row (e.g., 0, 1, 2, ...)
      final absoluteCellIndex = startingColumnIndex + colIndex;

      // If it's a unified row, all cells use the single tap. Otherwise, each uses its own.
      final effectiveTap = isUnifiedTapRow ? unifiedTap : cell.onTap;

      bool showIndicator = false;
      if (effectiveTap != null && !isSumRow) {
        // If there's ONE tap for the whole row, show the icon ONLY on the FIRST column.
        if (isUnifiedTapRow && absoluteCellIndex == 0) {
          showIndicator = true;
        }
        // If there are MULTIPLE taps, show the icon on each specific cell that has a tap.
        else if (!isUnifiedTapRow && cell.onTap != null) {
          showIndicator = true;
        }
      }

      // Build the cell with a GestureDetector and a conditional Stack for the icon
      return GestureDetector(
        onTap: effectiveTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(border: borderDecoration),
              width: double.infinity,
              constraints: BoxConstraints(minHeight: widget.titleMinHeight),
              child: cell,
            ),
            if (showIndicator)
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(
                  Platform.isIOS
                      ? CupertinoIcons.hand_point_right
                      : Icons.touch_app_outlined,
                  size: 14,
                  color: Theme.of(context).primaryColor.withAlpha(200),
                ),
              ),
          ],
        ),
      );
    }).toList();

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: rowChildren,
    );
  }

  Future<void> openPdfPage({
    required BuildContext context,
    required List<List<PersonalizedTableCell>> sortedRows,
    required List<PersonalizedTableCell> sumRow,
    required int? minValueRowIndex,
    required int? maxValueRowIndex,
  }) async {
    if (sortedRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There is no data to export.")),
      );
      return;
    }

    // 1. Instantiate the generator as before.
    final pdfGenerator = SaleStatisticPdfGenerator(
      pdfFileName: widget.pdfFileName, // Title in Portuguese
      titles: widget.titles,
      sortedRows: sortedRows,
      columnsWidths: widget.columnsWidths,
      sumRow: (widget.columnsIndexToSum?.isNotEmpty ?? false) ? sumRow : null,
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
}
