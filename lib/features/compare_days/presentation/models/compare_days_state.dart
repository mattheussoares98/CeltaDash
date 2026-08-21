import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class CompareDaysState extends Equatable {
  const CompareDaysState({
    required this.firstDayStatistics,
    required this.secondDayStatistics,
  });

  final List<SaleStatisticsEntity> firstDayStatistics;
  final List<SaleStatisticsEntity> secondDayStatistics;

  @override
  List<Object?> get props => [firstDayStatistics, secondDayStatistics];
}
