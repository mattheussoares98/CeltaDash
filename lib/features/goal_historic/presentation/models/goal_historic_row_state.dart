import 'package:equatable/equatable.dart';

class GoalHistoricRowState extends Equatable {
  const GoalHistoricRowState({
    required this.year,
    required this.month,
    required this.goalValue,
    required this.salesValue,
    this.isCustomGoal = false,
    this.customGoalAuthor,
  });

  final int year;
  final int month;
  final double goalValue;
  final double salesValue;
  final bool isCustomGoal;
  final String? customGoalAuthor;

  double get percentageValue =>
      goalValue > 0 ? (salesValue / goalValue) * 100 : 0.0;

  bool get isGoalReached => percentageValue >= 100.0;

  @override
  List<Object?> get props => [
    year,
    month,
    goalValue,
    salesValue,
    isCustomGoal,
    customGoalAuthor,
  ];
}
