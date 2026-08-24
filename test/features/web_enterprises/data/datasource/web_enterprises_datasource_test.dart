import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/features/web_enterprises/data/data.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart' hide MockFirebaseStorage;
import '../../mocks/mocks.dart';

void main() {
  late MockFirebaseStorage firebaseStorage;
  late WebEnterprisesDatasource datasource;

  setUp(() {
    firebaseStorage = MockFirebaseStorage();
    datasource = WebEnterprisesDatasource(firebaseStorage);
  });

  test('getEnterprises maps valid Firebase documents', () async {
    final entity = EntityFactory.makeFirebaseEnterpriseEntity();
    final document = FakeFirebaseDocument(
      FirebaseEnterpriseModel.fromEntity(entity).toJson(),
      entity.firebaseId!,
    );
    when(
      () => firebaseStorage.get(path: 'enterprises'),
    ).thenAnswer((_) async => FakeFirebaseQuery([document]));

    final result = await datasource.getEnterprises();

    expect(result.map((model) => model.toEntity()), [entity]);
    verify(() => firebaseStorage.get(path: 'enterprises')).called(1);
  });

  test('getAnalytics maps the selected monthly collection', () async {
    const document = FakeFirebaseDocument({
      'sales-daily': 3,
      'users': [],
    }, 'enterprise-1');
    when(
      () => firebaseStorage.get(path: 'analytics/2026-08/informations'),
    ).thenAnswer((_) async => const FakeFirebaseQuery([document]));

    final result = await datasource.getAnalytics(DateTime(2026, 8));

    expect(result.single.enterprise, 'enterprise-1');
    expect(
      result.single.searchCounts.single.reportType,
      WebAnalyticsReportType.sales,
    );
    verify(
      () => firebaseStorage.get(path: 'analytics/2026-08/informations'),
    ).called(1);
  });

  test('public loaders return empty lists for invalid snapshots', () async {
    when(
      () => firebaseStorage.get(path: 'enterprises'),
    ).thenAnswer((_) async => Object());
    when(
      () => firebaseStorage.get(path: 'analytics/2026-08/informations'),
    ).thenAnswer((_) async => Object());

    expect(await datasource.getEnterprises(), isEmpty);
    expect(await datasource.getAnalytics(DateTime(2026, 8)), isEmpty);
  });
}
