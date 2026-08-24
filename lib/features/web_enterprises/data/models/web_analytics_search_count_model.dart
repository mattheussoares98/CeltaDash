import 'package:celta_dash/features/web_enterprises/domain/domain.dart';

class WebAnalyticsSearchCountModel {
  final WebAnalyticsReportType reportType;
  final WebAnalyticsPeriodType periodType;
  final int count;

  const WebAnalyticsSearchCountModel({
    required this.reportType,
    required this.periodType,
    required this.count,
  });

  factory WebAnalyticsSearchCountModel.fromJson(Map json) =>
      WebAnalyticsSearchCountModel(
        reportType: WebAnalyticsReportType.values.byName(
          json['reportType'] as String,
        ),
        periodType: WebAnalyticsPeriodType.values.byName(
          json['periodType'] as String,
        ),
        count: json['count'] as int? ?? 0,
      );

  factory WebAnalyticsSearchCountModel.fromEntity(
    WebAnalyticsSearchCountEntity entity,
  ) => WebAnalyticsSearchCountModel(
    reportType: entity.reportType,
    periodType: entity.periodType,
    count: entity.count,
  );

  Map toJson() => {
    'reportType': reportType.name,
    'periodType': periodType.name,
    'count': count,
  };

  WebAnalyticsSearchCountEntity toEntity() => WebAnalyticsSearchCountEntity(
    reportType: reportType,
    periodType: periodType,
    count: count,
  );
}
