import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:faker/faker.dart';

abstract final class AppAnalyticsEntityFactory {
  static AppAnalyticsEntity makeAppAnalyticsEntity({
    String? enterprise,
    List<AppAnalyticsSearchCountEntity>? searchCounts,
    List<AppAnalyticsUserEntity>? users,
  }) {
    return AppAnalyticsEntity(
      enterprise: enterprise ?? faker.guid.guid(),
      searchCounts: searchCounts ?? [makeAppAnalyticsSearchCountEntity()],
      users: users ?? [makeAppAnalyticsUserEntity()],
    );
  }

  static AppAnalyticsSearchCountEntity makeAppAnalyticsSearchCountEntity({
    AppAnalyticsReportType? reportType,
    AppAnalyticsPeriodType? periodType,
    int? count,
  }) {
    return AppAnalyticsSearchCountEntity(
      reportType: reportType ?? AppAnalyticsReportType.sales,
      periodType: periodType ?? AppAnalyticsPeriodType.daily,
      count: count ?? faker.randomGenerator.integer(100, min: 1),
    );
  }

  static AppAnalyticsUserEntity makeAppAnalyticsUserEntity({
    String? userName,
    String? platform,
  }) {
    return AppAnalyticsUserEntity(
      userName: userName ?? faker.person.name(),
      platform: platform ?? 'web',
    );
  }
}
