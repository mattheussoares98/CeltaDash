// lib/features/compare_months/presentation/models/compare_months_dates_state.dart
import 'package:equatable/equatable.dart';

class CompareMonthsDatesState extends Equatable {
  const CompareMonthsDatesState({
    required this.firstMonth,
    required this.secondMonth,
  });

  final DateTime firstMonth;
  final DateTime secondMonth;

  CompareMonthsDatesState copyWith({
    DateTime? firstMonth,
    DateTime? secondMonth,
  }) =>
      CompareMonthsDatesState(
        firstMonth: firstMonth ?? this.firstMonth,
        secondMonth: secondMonth ?? this.secondMonth,
      );

  @override
  List<Object?> get props => [firstMonth, secondMonth];
}
