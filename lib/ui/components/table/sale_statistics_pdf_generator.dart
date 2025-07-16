import 'dart:typed_data';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Assuming 'PersonalizedTableCell' is defined in your project.
import '../../../domain/helpers/helpers.dart';
import '../../pages/pages.dart';
import 'table.dart'; // Make sure this import points to your PersonalizedTableCell definition.

class SaleStatisticPdfGenerator {
  final List<PersonalizedTableCell> titles;
  final List<List<PersonalizedTableCell>> sortedRows;
  final List<double> columnsWidths;
  final List<PersonalizedTableCell>? sumRow;
  final int? minValueRowIndex;
  final int? maxValueRowIndex;
  final String pdfFileName;
  final PeriodType? selectedPeriodType;

  SaleStatisticPdfGenerator({
    required this.titles,
    required this.sortedRows,
    required this.columnsWidths,
    required this.sumRow,
    required this.minValueRowIndex,
    required this.maxValueRowIndex,
    required this.pdfFileName,
    required this.selectedPeriodType,
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
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final selectedDate = Get.find<HomePresenter>().selectedDate;

    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(bottom: 16.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(pdfFileName,
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          // The text is now in Portuguese and uses the formatted date.
          pw.Row(children: [
            pw.Text(
              'Gerado em: ${formatter.format(now)}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
            if (selectedPeriodType != null) ...[
              pw.Text(
                ' - Data selecionada: ${DateFormat('dd/MM/yyyy').format(selectedDate)} - ',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Período: ${selectedPeriodType!.description}',
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
              ),
            ]
          ]),
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

  String _getFormattedValue(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is double) {
      // Mimics the behavior of formatting a double.
      // Replace with your `toBrazilianNumber()` if needed.
      return value.toString().toBrazilianNumber(value % 1 == 0 ? 0 : 2);
    } else if (value is int) {
      // Mimics formatting for an integer.
      return value.toString().toBrazilianNumber();
    } else if (value is num) {
      // Fallback for other numbers (e.g., if it has no decimal part).
      if (value % 1 == 0) {
        return value.toInt().toString();
      }
      return value.toString().toBrazilianNumber();
    }
    return 'error';
  }

  pw.Widget _buildCell(PersonalizedTableCell cell, {bool isHeader = false}) {
    // Main style for the numerical value
    final mainStyle = pw.TextStyle(
      fontWeight: isHeader || cell.isTitle == true
          ? pw.FontWeight.bold
          : pw.FontWeight.normal,
      fontSize: 8,
    );

    // A smaller, slightly lighter style for the currency and percentage symbols.
    final symbolStyle = mainStyle.copyWith(
      fontSize: 6,
      color: PdfColors.grey600,
    );

    final formattedValue = _getFormattedValue(cell.value);

    // The main content widget, which will be a RichText.
    final content = pw.RichText(
      textAlign: pw.TextAlign.center,
      text: pw.TextSpan(
        children: [
          // Conditionally add the 'R$' prefix.
          if (cell.isMoney == true)
            pw.TextSpan(
              text: 'R\$ ',
              style: symbolStyle,
            ),
          // The main value.
          pw.TextSpan(
            text: isHeader || cell.isTitle == true
                ? formattedValue.toUpperCase()
                : formattedValue,
            style: mainStyle,
          ),
          // Conditionally add the '%' suffix.
          if (cell.isPercentage == true)
            pw.TextSpan(
              text: ' %',
              style: symbolStyle,
            ),
        ],
      ),
    );

    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: (cell.subtile != null && cell.subtile!.isNotEmpty)
          // If a subtitle exists, wrap the content in a Column.
          ? pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                content,
                pw.SizedBox(height: 2),
                pw.Text(
                  isHeader || cell.isTitle == true
                      ? cell.subtile!.toUpperCase()
                      : cell.subtile!,
                  style: mainStyle.copyWith(fontSize: 6),
                ),
              ],
            )
          // Otherwise, just return the content.
          : content,
    );
  }

  /// Determines the background color for a given row index.
  PdfColor? _getPdfColor(int rowIndex) {
    if (rowIndex == maxValueRowIndex && sortedRows.length > 1) {
      return PdfColors.green200;
    } else if (rowIndex == minValueRowIndex && sortedRows.length > 1) {
      return PdfColors.red200;
    } else if (rowIndex % 2 != 0) {
      return PdfColors.grey200;
    }
    return PdfColors.white;
  }
}
