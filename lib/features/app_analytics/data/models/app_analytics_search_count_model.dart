// lib/features/app_analytics/data/models/app_analytics_search_count_model.dart
import 'package:celta_dash/features/app_analytics/domain/domain.dart';

class AppAnalyticsSearchCountModel {
  final AppAnalyticsReportType reportType;
  final AppAnalyticsPeriodType periodType;
  final int count;

  const AppAnalyticsSearchCountModel({
    required this.reportType,
    required this.periodType,
    required this.count,
  });

  factory AppAnalyticsSearchCountModel.fromJson(Map json) =>
      AppAnalyticsSearchCountModel(
        reportType: AppAnalyticsReportType.values.byName(
          json['reportType'] as String,
        ),
        periodType: AppAnalyticsPeriodType.values.byName(
          json['periodType'] as String,
        ),
        count: json['count'] as int? ?? 0,
      );

  factory AppAnalyticsSearchCountModel.fromEntity(
    AppAnalyticsSearchCountEntity entity,
  ) => AppAnalyticsSearchCountModel(
    reportType: entity.reportType,
    periodType: entity.periodType,
    count: entity.count,
  );

  Map toJson() => {
    'reportType': reportType.name,
    'periodType': periodType.name,
    'count': count,
  };

  AppAnalyticsSearchCountEntity toEntity() => AppAnalyticsSearchCountEntity(
    reportType: reportType,
    periodType: periodType,
    count: count,
  );
}
