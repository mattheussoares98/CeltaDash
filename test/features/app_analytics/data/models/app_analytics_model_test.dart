import 'package:celta_dash/features/app_analytics/data/data.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('fromJson parses users and valid search-count keys', () {
    final enterpriseId = faker.guid.guid();
    final userName = faker.person.name();
    final count = faker.randomGenerator.integer(100, min: 1);
    final model = AppAnalyticsModel.fromJson({
      'sales-daily': count,
      'financial-daily': count,
      'groupOfStores-daily': count,
      'compareMonths-monthly': count,
      'dailyComparison-daily': count,
      'invalid-key': faker.randomGenerator.integer(100),
      'users': [
        {'userName': userName, 'platform': 'web'},
      ],
    }, enterpriseId: enterpriseId);

    expect(model.enterprise, enterpriseId);
    expect(model.users.single.userName, userName);
    expect(
      model.searchCounts.map((e) => e.reportType),
      containsAll([
        AppAnalyticsReportType.sales,
        AppAnalyticsReportType.financial,
        AppAnalyticsReportType.groupOfStores,
        AppAnalyticsReportType.compareMonths,
        AppAnalyticsReportType.dailyComparison,
      ]),
    );
  });

  test('toJson and toEntity preserve analytics data', () {
    final entity = AppAnalyticsEntityFactory.makeAppAnalyticsEntity();

    final model = AppAnalyticsModel.fromEntity(entity);

    expect(model.toEntity(), entity);
    final searchCount = entity.searchCounts.single;
    expect(
      model
          .toJson()['${searchCount.reportType.name}-${searchCount.periodType.name}'],
      searchCount.count,
    );
  });
}
