import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:equatable/equatable.dart';

class MonthlyAnalysisState extends Equatable {
  const MonthlyAnalysisState({required this.totalSales, required this.days});

  final num totalSales;
  final List<MonthlyAnalysisDayState> days;

  bool get hasAnalysis => days.length > 1;

  double get averageDailySale => days.isEmpty
      ? 0
      : days.fold<double>(0, (total, day) => total + day.value) / days.length;

  MonthlyAnalysisDayState? get bestDay => days.isEmpty
      ? null
      : days.reduce((best, day) => day.value > best.value ? day : best);

  MonthlyAnalysisDayState? get worstDay => days.isEmpty
      ? null
      : days.reduce((worst, day) => day.value < worst.value ? day : worst);

  @override
  List<Object> get props => [totalSales, days];
}
