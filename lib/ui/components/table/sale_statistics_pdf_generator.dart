import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Assuming 'PersonalizedTableCell' is defined in your project.
import 'table.dart'; // Make sure this import points to your PersonalizedTableCell definition.

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

  /// Generates the PDF document and returns its data as a Uint8List.
  Future<Uint8List> generatePdfBytes() async {
    return _generatePdf();
  }

  /// Core logic to create the PDF document using the `pdf` package.
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        // This reduces the blank space on all sides of the page.
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4.landscape,
        header: (pw.Context context) => _buildHeader(),
        footer: (pw.Context context) => _buildFooter(context),
        build: (pw.Context context) => [
          _buildPdfTable(),
        ],
      ),
    );

    return pdf.save();
  }

  /// Builds the header for each page of the PDF.
  pw.Widget _buildHeader() {
    // This formats the date and time to a common Brazilian format.
    final now = DateTime.now().toLocal();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} às ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(bottom: 16.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(reportTitle,
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          // The text is now in Portuguese and uses the formatted date.
          pw.Text('Gerado em: $formattedDate',
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
        // The page information text is now in Portuguese.
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.Theme.of(context)
            .defaultTextStyle
            .copyWith(color: PdfColors.grey),
      ),
    );
  }

  /// Constructs the main table widget for the PDF.
  pw.Widget _buildPdfTable() {
    // 1. Define the header row.
    // By setting `repeat: true`, this specific TableRow will be drawn
    // at the top of every page the table spans.
    final headers = pw.TableRow(
      repeat: true, // THIS IS THE CORRECT IMPLEMENTATION
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: titles.map((cell) => _buildCell(cell, isHeader: true)).toList(),
    );

    // 2. Define the data rows.
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

    // 3. Define the sum row, if it exists.
    final pw.TableRow? pdfSumRow = sumRow != null
        ? pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: sumRow!
                .map((cell) => _buildCell(cell, isHeader: true))
                .toList(),
          )
        : null;

    // 4. Define Column Widths
    final Map<int, pw.TableColumnWidth> pdfColumnWidths = {
      for (int i = 0; i < columnsWidths.length; i++)
        i: pw.FlexColumnWidth(columnsWidths[i]),
    };

    // 5. Assemble the Table
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      columnWidths: pdfColumnWidths,
      // The children list starts with the repeatable header row.
      children: [
        headers,
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
      fontSize: 8,
    );

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
  PdfColor? _getPdfColor(int rowIndex) {
    if (rowIndex == maxValueRowIndex && sortedRows.length > 1) {
      return PdfColors.green50;
    } else if (rowIndex == minValueRowIndex && sortedRows.length > 1) {
      return PdfColors.red50;
    } else if (rowIndex % 2 != 0) {
      return PdfColors.grey100;
    }
    return PdfColors.white;
  }
}

/// Extension to easily convert Flutter's Alignment to PDF's Alignment.
extension AlignmentConverter on Alignment {
  pw.Alignment toPdfAlignment() {
    return pw.Alignment(x, y);
  }
}
