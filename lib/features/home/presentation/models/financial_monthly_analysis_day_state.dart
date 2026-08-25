// lib/features/home/presentation/models/financial_monthly_analysis_day_state.dart
import 'package:equatable/equatable.dart';

class FinancialMonthlyAnalysisDayState extends Equatable {
  const FinancialMonthlyAnalysisDayState({
    required this.date,
    required this.receiveValue,
    required this.payValue,
  });

  final DateTime date;
  final double receiveValue;
  final double payValue;

  double get balance => receiveValue - payValue;

  @override
  List<Object?> get props => [date, receiveValue, payValue];
}
