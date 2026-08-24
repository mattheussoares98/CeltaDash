import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestRow {
  final String name;
  final double value;
  final double percentage;

  const _TestRow({
    required this.name,
    required this.value,
    required this.percentage,
  });
}

void main() {
  group('ScrollableTableColumnSpec Export Tests', () {
    test('getExportValue formats money using sortValueMapper fallback', () {
      final spec = ScrollableTableColumnSpec<_TestRow>(
        headerTitle: 'Valor',
        isMoney: true,
        cellBuilder: (item) => Text(item.value.toString()),
        sortValueMapper: (item) => item.value,
      );

      const row = _TestRow(name: 'Item 1', value: 1250.50, percentage: 10.0);
      expect(spec.getExportValue(row), contains('1.250,50'));
    });

    test('getExportValue uses custom textValueMapper when provided', () {
      final spec = ScrollableTableColumnSpec<_TestRow>(
        headerTitle: 'Nome',
        cellBuilder: (item) => Text(item.name),
        textValueMapper: (item) => 'Custom: ${item.name}',
      );

      const row = _TestRow(name: 'Item 1', value: 10, percentage: 5);
      expect(spec.getExportValue(row), equals('Custom: Item 1'));
    });

    test('getExportFooterValue formats footer summary correctly', () {
      final spec = ScrollableTableColumnSpec<_TestRow>(
        headerTitle: 'Total',
        cellBuilder: (item) => Text(item.value.toString()),
        footerTextValueMapper: (items) => items
            .fold<double>(0, (sum, i) => sum + i.value)
            .toStringAsFixed(2),
      );

      final items = [
        const _TestRow(name: 'A', value: 10.0, percentage: 1),
        const _TestRow(name: 'B', value: 20.0, percentage: 2),
      ];

      expect(spec.getExportFooterValue(items), equals('30.00'));
    });
  });

  group('TablePdfGenerator Tests', () {
    test('generatePdfBytes produces valid non-empty PDF bytes', () async {
      final columns = [
        ScrollableTableColumnSpec<_TestRow>(
          headerTitle: 'Nome',
          cellBuilder: (item) => Text(item.name),
          sortValueMapper: (item) => item.name,
        ),
        ScrollableTableColumnSpec<_TestRow>(
          headerTitle: 'Valor',
          isMoney: true,
          cellBuilder: (item) => Text(item.value.toString()),
          sortValueMapper: (item) => item.value,
          footerTextValueMapper: (items) => 'R\$ 300,00',
        ),
      ];

      final items = [
        const _TestRow(name: 'Alpha', value: 100.0, percentage: 10),
        const _TestRow(name: 'Beta', value: 200.0, percentage: 20),
      ];

      final generator = TablePdfGenerator<_TestRow>(
        pdfFileName: 'Relatório Teste',
        pdfSubtitle: 'Período: 01/01/2026 até 31/01/2026',
        columns: columns,
        sortedItems: items,
        highlightColumnIndex: 1,
      );

      final bytes = await generator.generatePdfBytes();
      expect(bytes, isNotNull);
      expect(bytes.isNotEmpty, isTrue);
      // PDF documents start with %PDF header (0x25, 0x50, 0x44, 0x46)
      expect(bytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
