import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockWebEnterprisesDatasource datasource;
  late WebEnterprisesRepositoryImpl repository;

  setUp(() {
    datasource = MockWebEnterprisesDatasource();
    repository = WebEnterprisesRepositoryImpl(datasource);
  });

  test('getEnterprises forwards the datasource result', () async {
    final enterprises = [EntityFactory.makeFirebaseEnterpriseEntity()];
    when(datasource.getEnterprises).thenAnswer((_) async => enterprises);

    expect(await repository.getEnterprises(), enterprises);
    verify(datasource.getEnterprises).called(1);
  });

  test('getAnalytics forwards the period and result', () async {
    final period = DateTime(2026, 8);
    const analytics = <MonthlyAnalyticsEntity>[];
    when(
      () => datasource.getAnalytics(period),
    ).thenAnswer((_) async => analytics);

    expect(await repository.getAnalytics(period), analytics);
    verify(() => datasource.getAnalytics(period)).called(1);
  });
}
