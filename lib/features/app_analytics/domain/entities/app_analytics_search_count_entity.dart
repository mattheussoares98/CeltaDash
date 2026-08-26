// lib/features/app_analytics/domain/entities/app_analytics_search_count_entity.dart
import 'package:celta_dash/features/app_analytics/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class AppAnalyticsSearchCountEntity extends Equatable {
  final AppAnalyticsReportType reportType;
  final AppAnalyticsPeriodType periodType;
  final int count;

  const AppAnalyticsSearchCountEntity({
    required this.reportType,
    required this.periodType,
    required this.count,
  });

  AppAnalyticsSearchCountEntity copyWith({
    AppAnalyticsReportType? reportType,
    AppAnalyticsPeriodType? periodType,
    int? count,
  }) => AppAnalyticsSearchCountEntity(
    reportType: reportType ?? this.reportType,
    periodType: periodType ?? this.periodType,
    count: count ?? this.count,
  );

  @override
  List<Object?> get props => [reportType, periodType, count];
}
