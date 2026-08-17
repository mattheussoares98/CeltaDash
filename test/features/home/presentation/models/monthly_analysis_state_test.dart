import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns safe defaults when there are no analyzed days', () {
    const state = MonthlyAnalysisState(totalSales: 0, days: []);

    expect(state.hasAnalysis, isFalse);
    expect(state.averageDailySale, 0);
    expect(state.bestDay, isNull);
    expect(state.worstDay, isNull);
  });

  test('calculates the average, best day, and worst day', () {
    final state = MonthlyAnalysisState(
      totalSales: 600,
      days: [
        MonthlyAnalysisDayState(date: DateTime(2026, 8), value: 100),
        MonthlyAnalysisDayState(date: DateTime(2026, 8, 2), value: 300),
        MonthlyAnalysisDayState(date: DateTime(2026, 8, 3), value: 200),
      ],
    );

    expect(state.hasAnalysis, isTrue);
    expect(state.averageDailySale, 200);
    expect(state.bestDay?.date, DateTime(2026, 8, 2));
    expect(state.worstDay?.date, DateTime(2026, 8));
  });
}
