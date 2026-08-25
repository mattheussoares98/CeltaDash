// lib/features/compare_months/presentation/models/compare_months_row_state.dart
import 'package:equatable/equatable.dart';

class CompareMonthsRowState extends Equatable {
  const CompareMonthsRowState({
    required this.day,
    required this.firstMonthValue,
    required this.secondMonthValue,
  });

  final int day;
  final num firstMonthValue;
  final num secondMonthValue;

  num get percentageDifference {
    if (firstMonthValue == 0 && secondMonthValue == 0) return 0;
    if (firstMonthValue == 0) return -100;
    return ((firstMonthValue - secondMonthValue) / firstMonthValue) * 100;
  }

  @override
  List<Object?> get props => [day, firstMonthValue, secondMonthValue];
}
