import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson parses users and valid search-count keys', () {
    final model = WebAnalyticsModel.fromJson({
      'sales-daily': 4,
      'invalid-key': 9,
      'users': [
        {'userName': 'Maria', 'platform': 'web'},
      ],
    }, enterpriseId: 'enterprise-1');

    expect(model.enterprise, 'enterprise-1');
    expect(model.users.single.userName, 'Maria');
    expect(
      model.searchCounts.single,
      const SearchCountEntity(
        reportType: ReportType.sales,
        periodType: PeriodType.daily,
        count: 4,
      ),
    );
  });

  test('toJson and toEntity preserve analytics data', () {
    const entity = MonthlyAnalyticsEntity(
      enterprise: 'enterprise-1',
      searchCounts: [
        SearchCountEntity(
          reportType: ReportType.sales,
          periodType: PeriodType.daily,
          count: 4,
        ),
      ],
      users: [ActiveUserEntity(userName: 'Maria', platform: 'web')],
    );

    final model = WebAnalyticsModel.fromEntity(entity);

    expect(model.toEntity(), entity);
    expect(model.toJson()['sales-daily'], 4);
  });
}
