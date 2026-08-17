import 'package:equatable/equatable.dart';

class MonthlyGoalComparisonState extends Equatable {
  const MonthlyGoalComparisonState({
    required this.selectedDate,
    required this.comparisonDate,
    required this.currentMonthLiquidValue,
    required this.comparisonLiquidValue,
    required this.selectedDayLiquidValue,
  });

  final DateTime selectedDate;
  final DateTime comparisonDate;
  final num currentMonthLiquidValue;
  final num comparisonLiquidValue;
  final num selectedDayLiquidValue;

  double get monthlyGoal => comparisonLiquidValue * 1.05;

  int get comparisonMonthDays =>
      DateTime(comparisonDate.year, comparisonDate.month + 1, 0).day;

  double get dailyGoal => monthlyGoal / comparisonMonthDays;

  bool get hasGoal => monthlyGoal > 0;

  @override
  List<Object> get props => [
    selectedDate,
    comparisonDate,
    currentMonthLiquidValue,
    comparisonLiquidValue,
    selectedDayLiquidValue,
  ];
}
