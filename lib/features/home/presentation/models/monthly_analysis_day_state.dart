import 'package:equatable/equatable.dart';

class MonthlyAnalysisDayState extends Equatable {
  const MonthlyAnalysisDayState({required this.date, required this.value});

  final DateTime date;
  final double value;

  @override
  List<Object> get props => [date, value];
}
