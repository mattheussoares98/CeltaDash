import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:faker/faker.dart';

class WebEnterprisesEntityFactory {
  WebEnterprisesEntityFactory._();

  static WebAnalyticsEntity makeWebAnalyticsEntity() => WebAnalyticsEntity(
    enterprise: faker.guid.guid(),
    searchCounts: [
      WebAnalyticsSearchCountEntity(
        reportType: WebAnalyticsReportType.sales,
        periodType: WebAnalyticsPeriodType.daily,
        count: faker.randomGenerator.integer(100),
      ),
    ],
    users: [
      WebAnalyticsUserEntity(
        userName: faker.person.name(),
        platform: faker.randomGenerator.element(['web', 'android', 'ios']),
      ),
    ],
  );
}
