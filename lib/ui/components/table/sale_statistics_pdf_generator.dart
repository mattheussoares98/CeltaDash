import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Assuming 'PersonalizedTableCell' is defined in your project.
// This is a placeholder based on the usage in your 'ScrollableTableItem'.
import 'table.dart'; // Make sure this import points to your PersonalizedTableCell definition.

/// A class responsible for generating a PDF from sale statistics data.
/// It's designed to take the processed data from your `ScrollableTableItem`
/// and format it into a PDF table that mirrors the UI.
class SaleStatisticPdfGenerator {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> sortedRows;
  final List<double> columnsWidths;
  final List<PersonalizedTableCell>? sumRow;
  final int? minValueRowIndex;
  final int? maxValueRowIndex;
  final String reportTitle;

  SaleStatisticPdfGenerator({
    required this.titles,
    required this.sortedRows,
    required this.columnsWidths,
    required this.sumRow,
    required this.minValueRowIndex,
    required this.maxValueRowIndex,
    this.reportTitle = 'Sales Statistics Report',
  });

  /// Generates the PDF document and opens a print/save preview screen.
  Future<void> generateAndPrintPdf() async {
    // Generate the PDF document in memory.
    final Uint8List pdfBytes = await _generatePdf();

    // Use the `printing` package to display the PDF preview.
    // This allows the user to print, save, or share the document.
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  /// Core logic to create the PDF document using the `pdf` package.
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    // Add a page to the document. We use `MultiPage` to allow the table
    // to span across multiple pages if it's too long.
    // The page format is set to landscape to better accommodate wide tables.
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (pw.Context context) => _buildHeader(),
        footer: (pw.Context context) => _buildFooter(context),
        build: (pw.Context context) => [
          _buildPdfTable(),
        ],
      ),
    );

    // `pdf.save()` returns the document as a `Uint8List`.
    return pdf.save();
  }

  /// Builds the header for each page of the PDF.
  pw.Widget _buildHeader() {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(bottom: 16.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(reportTitle,
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          pw.Text('Generated on: ${DateTime.now().toLocal()}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
        ],
      ),
    );
  }

  /// Builds the footer for each page, showing the page number.
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 16.0),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: pw.Theme.of(context)
            .defaultTextStyle
            .copyWith(color: PdfColors.grey),
      ),
    );
  }

  /// Constructs the main table widget for the PDF.
  pw.Widget _buildPdfTable() {
    // 1. Define Table Headers
    // The headers are styled to be bold and have a light grey background.
    final headers =
        titles.map((cell) => _buildCell(cell, isHeader: true)).toList();

    // 2. Define Data Rows
    // Each row from `sortedRows` is converted into a `pw.TableRow`.
    // The row color is determined based on its index (for alternating colors)
    // and whether it's a min/max value row.
    final List<pw.TableRow> rows = [];
    for (int i = 0; i < sortedRows.length; i++) {
      final rowData = sortedRows[i];
      final pdfColor = _getPdfColor(i);
      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(color: pdfColor),
          children: rowData.map((cell) => _buildCell(cell)).toList(),
        ),
      );
    }

    // 3. Define Sum Row
    // If a sum row exists, it's added at the end of the table with header styling.
    final pw.TableRow? pdfSumRow = sumRow != null
        ? pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: sumRow!
                .map((cell) => _buildCell(cell, isHeader: true))
                .toList(),
          )
        : null;

    // 4. Define Column Widths
    // The column widths from the Flutter widget are converted to relative widths
    // for the PDF table, ensuring a similar layout.
    final Map<int, pw.TableColumnWidth> pdfColumnWidths = {
      for (int i = 0; i < columnsWidths.length; i++)
        i: pw.FlexColumnWidth(columnsWidths[i]),
    };

    // 5. Assemble the Table
    // The final table is created with borders, column widths, and all the rows.
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      columnWidths: pdfColumnWidths,
      // The children are the header, all data rows, and the optional sum row.
      children: [
        pw.TableRow(children: headers),
        ...rows,
        if (pdfSumRow != null) pdfSumRow,
      ],
    );
  }

  /// Helper function to create a single styled cell (`pw.Widget`) for the table.
  pw.Widget _buildCell(PersonalizedTableCell cell, {bool isHeader = false}) {
    final style = pw.TextStyle(
      fontWeight: isHeader || cell.isTitle == true
          ? pw.FontWeight.bold
          : pw.FontWeight.normal,
      fontSize: 8, // Using a smaller font size to fit more data
    );

    // Basic text formatting based on cell properties.
    // This can be expanded to match your `toBrazilianNumber` logic.
    String value = cell.value.toString();
    if (cell.isMoney == true) {
      value = 'R\$ $value';
    }
    if (cell.isPercentage == true) {
      value = '$value%';
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      alignment: Alignment.center.toPdfAlignment(),
      child: pw.Text(value, style: style, textAlign: pw.TextAlign.center),
    );
  }

  /// Determines the background color for a given row index.
  /// This logic mirrors the `getColor` method in your widget.
  PdfColor? _getPdfColor(int rowIndex) {
    if (rowIndex == maxValueRowIndex && sortedRows.length > 1) {
      return PdfColors.green50; // Light green for best value
    } else if (rowIndex == minValueRowIndex && sortedRows.length > 1) {
      return PdfColors.red50; // Light red for worst value
    } else if (rowIndex % 2 != 0) {
      return PdfColors.grey100; // Light grey for alternating rows
    }
    return PdfColors.white; // Default background
  }
}

/// Extension to easily convert Flutter's Alignment to PDF's Alignment.
extension AlignmentConverter on Alignment {
  pw.Alignment toPdfAlignment() {
    return pw.Alignment(x, y);
  }
}
