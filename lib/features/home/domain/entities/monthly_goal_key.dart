import 'package:equatable/equatable.dart';

class MonthlyGoalKey extends Equatable {
  const MonthlyGoalKey({
    required this.enterpriseId,
    required this.year,
    required this.month,
  });

  final int enterpriseId;
  final int year;
  final int month;

  @override
  List<Object> get props => [enterpriseId, year, month];
}
