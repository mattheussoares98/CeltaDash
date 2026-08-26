// lib/features/app_analytics/domain/repository/i_app_analytics_repository.dart
import 'package:celta_dash/features/app_analytics/domain/entities/entities.dart';

abstract class IAppAnalyticsRepository {
  Future<List<AppAnalyticsEntity>> getAnalytics(DateTime period);

  Future<void> addNewMonthlyAnalytic({
    required AppAnalyticsReportType reportType,
    required AppAnalyticsPeriodType periodType,
  });
}
