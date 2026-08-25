// lib/features/departments/presentation/models/departments_statistics_row_state.dart
import 'package:equatable/equatable.dart';

class DepartmentsStatisticsRowState extends Equatable {
  const DepartmentsStatisticsRowState({
    required this.department,
    required this.sales,
    required this.cost,
    required this.profit,
    required this.margin,
    required this.share,
  });

  final String department;
  final double sales;
  final double cost;
  final double profit;
  final double margin;
  final double share;

  @override
  List<Object?> get props => [
    department,
    sales,
    cost,
    profit,
    margin,
    share,
  ];
}
