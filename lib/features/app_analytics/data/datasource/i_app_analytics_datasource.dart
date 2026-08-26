// lib/features/app_analytics/data/datasource/i_app_analytics_datasource.dart
import 'package:celta_dash/features/app_analytics/data/models/models.dart';

abstract class IAppAnalyticsDatasource {
  Future<List<AppAnalyticsModel>> getAnalytics(DateTime period);

  Future<AppAnalyticsModel> loadLocalMonthlyAnalytics({
    required String enterpriseId,
  });

  Future<void> saveLocalMonthlyAnalytics(AppAnalyticsModel model);

  Future<void> clearLocalMonthlyAnalytics();

  Future<void> syncAnalytics({
    required String docId,
    required String enterpriseName,
    required AppAnalyticsModel model,
  });

  Future<DateTime?> getLastSyncDate();

  Future<void> saveLastSyncDate(DateTime date);
}
