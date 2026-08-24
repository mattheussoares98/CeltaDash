import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('fromJson parses users and valid search-count keys', () {
    final enterpriseId = faker.guid.guid();
    final userName = faker.person.name();
    final count = faker.randomGenerator.integer(100, min: 1);
    final model = WebAnalyticsModel.fromJson({
      'sales-daily': count,
      'invalid-key': faker.randomGenerator.integer(100),
      'users': [
        {'userName': userName, 'platform': 'web'},
      ],
    }, enterpriseId: enterpriseId);

    expect(model.enterprise, enterpriseId);
    expect(model.users.single.userName, userName);
    expect(model.searchCounts.single.reportType, WebAnalyticsReportType.sales);
    expect(model.searchCounts.single.periodType, WebAnalyticsPeriodType.daily);
    expect(model.searchCounts.single.count, count);
  });

  test('toJson and toEntity preserve analytics data', () {
    final entity = WebEnterprisesEntityFactory.makeWebAnalyticsEntity();

    final model = WebAnalyticsModel.fromEntity(entity);

    expect(model.toEntity(), entity);
    final searchCount = entity.searchCounts.single;
    expect(
      model
          .toJson()['${searchCount.reportType.name}-${searchCount.periodType.name}'],
      searchCount.count,
    );
  });
}
