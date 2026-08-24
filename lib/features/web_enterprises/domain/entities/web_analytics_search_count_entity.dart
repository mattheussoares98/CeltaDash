import 'package:celta_dash/features/web_enterprises/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class WebAnalyticsSearchCountEntity extends Equatable {
  final WebAnalyticsReportType reportType;
  final WebAnalyticsPeriodType periodType;
  final int count;

  const WebAnalyticsSearchCountEntity({
    required this.reportType,
    required this.periodType,
    required this.count,
  });

  WebAnalyticsSearchCountEntity copyWith({
    WebAnalyticsReportType? reportType,
    WebAnalyticsPeriodType? periodType,
    int? count,
  }) => WebAnalyticsSearchCountEntity(
    reportType: reportType ?? this.reportType,
    periodType: periodType ?? this.periodType,
    count: count ?? this.count,
  );

  @override
  List<Object?> get props => [reportType, periodType, count];
}
