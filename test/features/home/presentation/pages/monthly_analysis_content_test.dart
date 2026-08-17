import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

    expect(find.text('ANÁLISE MENSAL'), findsOneWidget);
    expect(find.text('Total de vendas'), findsOneWidget);
    expect(find.text('Venda média diária'), findsOneWidget);
    expect(find.text('Melhor dia do mês'), findsOneWidget);
    expect(find.text('Pior dia do mês'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });
}
