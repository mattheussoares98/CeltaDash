import 'dart:typed_data';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TablePdfGenerator<T> {
  final String pdfFileName;
  final String? pdfSubtitle;
  final String? enterpriseName;
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<T> sortedItems;
  final int? highlightColumnIndex;

  const TablePdfGenerator({
    required this.pdfFileName,
    this.pdfSubtitle,
    this.enterpriseName,
    required this.columns,
    required this.sortedItems,
    this.highlightColumnIndex,
  });

  /// Generates the complete PDF document and returns its bytes.
  Future<Uint8List> generatePdfBytes() async {
    final pdf = pw.Document();

    final (bestRow, worstRow) = _computeBestAndWorst();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(12),
        pageFormat: PdfPageFormat.a4.landscape,
        header: (pw.Context context) => _buildHeader(),
        footer: (pw.Context context) => _buildFooter(context),
        build: (pw.Context context) => [
          _buildPdfTable(bestRow: bestRow, worstRow: worstRow),
        ],
      ),
    );

    return pdf.save();
  }

  (T?, T?) _computeBestAndWorst() {
    if (highlightColumnIndex == null || sortedItems.length <= 1) {
      return (null, null);
    }
    if (highlightColumnIndex! < 0 || highlightColumnIndex! >= columns.length) {
      return (null, null);
    }

    final mapper = columns[highlightColumnIndex!].sortValueMapper;
    if (mapper == null) return (null, null);

    T best = sortedItems.first;
    T worst = sortedItems.first;
    Comparable bestVal = mapper(best);
    Comparable worstVal = bestVal;

    for (int i = 1; i < sortedItems.length; i++) {
      final item = sortedItems[i];
      final val = mapper(item);
      if (val.compareTo(bestVal) > 0) {
        bestVal = val;
        best = item;
      } else if (val.compareTo(worstVal) < 0) {
        worstVal = val;
        worst = item;
      }
    }

    if (bestVal == worstVal) return (null, null);
    return (best, worst);
  }

  pw.Widget _buildHeader() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                pdfFileName,
                style: const pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (enterpriseName != null && enterpriseName!.isNotEmpty)
                pw.Text(
                  enterpriseName!,
                  style: const pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    color: PdfColors.grey800,
                  ),
                ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Row(
            children: [
              pw.Text(
                'Gerado em: ${formatter.format(now)}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
              if (pdfSubtitle != null && pdfSubtitle!.isNotEmpty) ...[
                pw.Text(
                  ' - $pdfSubtitle',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ],
          ),
          pw.SizedBox(height: 6),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8.0),
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
      ),
    );
  }

  pw.Widget _buildPdfTable({T? bestRow, T? worstRow}) {
    final headerRow = pw.TableRow(
      repeat: true,
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: columns.map((col) {
        final title = col.isMoney == true
            ? '${col.headerTitle} (R\$)'
            : col.isPercentage == true
            ? '${col.headerTitle} (%)'
            : col.headerTitle;
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          alignment: pw.Alignment.center,
          child: pw.Text(
            title.toUpperCase(),
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
            ),
          ),
        );
      }).toList(),
    );

    final List<pw.TableRow> dataRows = [];
    for (int i = 0; i < sortedItems.length; i++) {
      final item = sortedItems[i];
      final isBest = bestRow != null && item == bestRow;
      final isWorst = worstRow != null && item == worstRow;

      final rowBgColor = isBest
          ? PdfColors.green100
          : isWorst
          ? PdfColors.red100
          : (i % 2 != 0 ? PdfColors.grey100 : PdfColors.white);

      dataRows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(color: rowBgColor),
          children: columns.map((col) {
            final cellText = col.getExportValue(item);
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              alignment: pw.Alignment.center,
              child: pw.Text(
                cellText,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 7.5),
              ),
            );
          }).toList(),
        ),
      );
    }

    final hasFooter = columns.any(
      (col) =>
          col.footerTextValueMapper != null || col.footerCellBuilder != null,
    );
    pw.TableRow? summaryRow;
    if (hasFooter) {
      summaryRow = pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: columns.map((col) {
          final footerText = col.getExportFooterValue(sortedItems) ?? '';
          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            alignment: pw.Alignment.center,
            child: pw.Text(
              footerText,
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
              ),
            ),
          );
        }).toList(),
      );
    }

    final Map<int, pw.TableColumnWidth> columnWidths = {
      for (int i = 0; i < columns.length; i++)
        i: pw.FlexColumnWidth(columns[i].effectiveMinWidth),
    };

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
      columnWidths: columnWidths,
      children: [headerRow, ...dataRows, ?summaryRow],
    );
  }
}
