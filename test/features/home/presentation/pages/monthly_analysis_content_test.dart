import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  testWidgets('shows summaries, highlights, and the monthly chart', (
    tester,
  ) async {
    final analysis = MonthlyAnalysisState(
      totalSales: 400,
      days: [
        MonthlyAnalysisDayState(date: DateTime(2026, 8), value: 100),
        MonthlyAnalysisDayState(date: DateTime(2026, 8, 2), value: 300),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MonthlyAnalysisContent(analysis: analysis)),
      ),
    );

    expect(find.text('Faturamento mensal'), findsOneWidget);
    expect(find.text('Ticket médio'), findsOneWidget);
    expect(find.textContaining('Melhor dia'), findsOneWidget);
    expect(find.textContaining('Pior dia'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });
}
