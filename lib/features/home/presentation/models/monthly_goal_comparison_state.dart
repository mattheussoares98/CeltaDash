import 'package:equatable/equatable.dart';

class MonthlyGoalComparisonState extends Equatable {
  const MonthlyGoalComparisonState({
    required this.selectedDate,
    required this.comparisonDate,
    required this.currentMonthLiquidValue,
    required this.comparisonLiquidValue,
    required this.selectedDayLiquidValue,
    this.customMonthlyGoal,
  });

  final DateTime selectedDate;
  final DateTime comparisonDate;
  final num currentMonthLiquidValue;
  final num comparisonLiquidValue;
  final num selectedDayLiquidValue;
  final double? customMonthlyGoal;

  double get monthlyGoal => customMonthlyGoal ?? comparisonLiquidValue * 1.05;

  int get comparisonMonthDays =>
      DateTime(comparisonDate.year, comparisonDate.month + 1, 0).day;

  int get selectedMonthDays =>
      DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

  double get dailyGoal =>
      monthlyGoal /
      (customMonthlyGoal == null ? comparisonMonthDays : selectedMonthDays);

  bool get hasGoal => monthlyGoal > 0;

  MonthlyGoalComparisonState copyWith({double? customMonthlyGoal}) =>
      MonthlyGoalComparisonState(
        selectedDate: selectedDate,
        comparisonDate: comparisonDate,
        currentMonthLiquidValue: currentMonthLiquidValue,
        comparisonLiquidValue: comparisonLiquidValue,
        selectedDayLiquidValue: selectedDayLiquidValue,
        customMonthlyGoal: customMonthlyGoal ?? this.customMonthlyGoal,
      );

  @override
  List<Object?> get props => [
    selectedDate,
    comparisonDate,
    currentMonthLiquidValue,
    comparisonLiquidValue,
    selectedDayLiquidValue,
    customMonthlyGoal,
  ];
}
