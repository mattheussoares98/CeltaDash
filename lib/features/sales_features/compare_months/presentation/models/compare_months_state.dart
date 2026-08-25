// lib/features/compare_months/presentation/models/compare_months_state.dart
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class CompareMonthsState extends Equatable {
  const CompareMonthsState({
    required this.firstMonthStatistics,
    required this.secondMonthStatistics,
  });

  final List<SaleStatisticsEntity> firstMonthStatistics;
  final List<SaleStatisticsEntity> secondMonthStatistics;

  @override
  List<Object?> get props => [firstMonthStatistics, secondMonthStatistics];
}
