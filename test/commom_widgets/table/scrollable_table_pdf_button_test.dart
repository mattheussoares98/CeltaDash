import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _DummyRow {
  final String id;
  final String title;

  const _DummyRow({required this.id, required this.title});
}

void main() {
  testWidgets('ScrollableTable renders PDF icon button on first column header when pdfFileName is set', (
    tester,
  ) async {
    bool pdfTapped = false;

    final columns = [
      ScrollableTableColumnSpec<_DummyRow>(
        headerTitle: 'Cupom',
        cellBuilder: (row) => Text(row.id),
        sortValueMapper: (row) => row.id,
      ),
      ScrollableTableColumnSpec<_DummyRow>(
        headerTitle: 'Título',
        cellBuilder: (row) => Text(row.title),
        sortValueMapper: (row) => row.title,
      ),
    ];

    final items = [
      const _DummyRow(id: '001', title: 'Test A'),
      const _DummyRow(id: '002', title: 'Test B'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScrollableTable<_DummyRow>(
            pdfFileName: 'Vendas',
            onExportPdf: () {
              pdfTapped = true;
            },
            items: items,
            columns: columns,
            fixFirstColumn: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify PDF icon is found in the widget tree
    final pdfIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is PlatformIcon &&
          (widget.materialIcon == Icons.picture_as_pdf_outlined ||
              widget.cupertinoIcon == CupertinoIcons.doc_text),
    );

    expect(pdfIconFinder, findsOneWidget);

    // Tap the PDF icon
    await tester.tap(pdfIconFinder);
    await tester.pump();

    expect(pdfTapped, isTrue);
  });
}
