import 'package:celta_dash/features/sales_features/goal_historic/presentation/models/models.dart';
import 'package:equatable/equatable.dart';

class GoalHistoricState extends Equatable {
  const GoalHistoricState({required this.selectedYear, required this.rows});

  final int selectedYear;
  final List<GoalHistoricRowState> rows;

  double get totalGoal =>
      rows.fold<double>(0.0, (total, row) => total + row.goalValue);

  double get totalSales =>
      rows.fold<double>(0.0, (total, row) => total + row.salesValue);

  double get totalPercentage =>
      totalGoal > 0 ? (totalSales / totalGoal) * 100 : 0.0;

  @override
  List<Object> get props => [selectedYear, rows];
}
