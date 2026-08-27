import 'package:celta_dash/features/app_analytics/data/data.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockFirebaseStorage firebaseStorage;
  late MockLocalStorage localStorage;
  late AppAnalyticsDatasource datasource;

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  setUp(() {
    firebaseStorage = MockFirebaseStorage();
    localStorage = MockLocalStorage();
    datasource = AppAnalyticsDatasource(
      firebaseStorage: firebaseStorage,
      localStorage: localStorage,
    );
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
      AppAnalyticsReportType.sales,
    );
    expect(result.single.searchCounts.single.count, 3);
  });

  test('getAnalytics returns empty list for invalid snapshot', () async {
    when(
      () => firebaseStorage.get(path: 'analytics/2026-08/informations'),
    ).thenAnswer((_) async => Object());

    expect(await datasource.getAnalytics(DateTime(2026, 8)), isEmpty);
  });

  test('loadLocalMonthlyAnalytics loads and maps local storage data', () async {
    when(
      () => localStorage.get(DatabaseKeys.monthlyAnalytics.name),
    ).thenAnswer((_) async => {
      'sales-daily': 2,
      'users': [
        {'userName': 'celta', 'platform': 'android'}
      ],
    });

    final result = await datasource.loadLocalMonthlyAnalytics(
      enterpriseId: 'enterprise-1',
    );

    expect(result.enterprise, 'enterprise-1');
    expect(result.searchCounts.single.reportType, AppAnalyticsReportType.sales);
    expect(result.searchCounts.single.count, 2);
    expect(result.users.single.userName, 'celta');
  });

  test('saveLocalMonthlyAnalytics and clearLocalMonthlyAnalytics interact with storage', () async {
    const model = AppAnalyticsModel(
      searchCounts: [],
      users: [],
      enterprise: 'enterprise-1',
    );
    when(
      () => localStorage.put(DatabaseKeys.monthlyAnalytics.name, any()),
    ).thenAnswer((_) async {});
    when(
      () => localStorage.delete(DatabaseKeys.monthlyAnalytics.name),
    ).thenAnswer((_) async {});

    await datasource.saveLocalMonthlyAnalytics(model);
    await datasource.clearLocalMonthlyAnalytics();

    verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics.name, any())).called(1);
    verify(() => localStorage.delete(DatabaseKeys.monthlyAnalytics.name)).called(1);
  });

  test('getLastSyncDate and saveLastSyncDate manage sync timestamps', () async {
    final now = DateTime(2026, 8, 26);
    when(
      () => localStorage.get(DatabaseKeys.lastAnalyticsSyncDate.name),
    ).thenAnswer((_) async => now.toIso8601String());
    when(
      () => localStorage.put(DatabaseKeys.lastAnalyticsSyncDate.name, any()),
    ).thenAnswer((_) async {});

    final retrieved = await datasource.getLastSyncDate();
    expect(retrieved, now);

    await datasource.saveLastSyncDate(now);
    verify(
      () => localStorage.put(
        DatabaseKeys.lastAnalyticsSyncDate.name,
        now.toIso8601String(),
      ),
    ).called(1);
  });

  test('syncAnalytics puts data to firebase path with merge', () async {
    when(
      () => firebaseStorage.put(
        path: any(named: 'path'),
        data: any(named: 'data'),
        merge: any(named: 'merge'),
      ),
    ).thenAnswer((_) async {});

    const model = AppAnalyticsModel(
      searchCounts: [
        AppAnalyticsSearchCountModel(
          reportType: AppAnalyticsReportType.sales,
          periodType: AppAnalyticsPeriodType.daily,
          count: 1,
        ),
      ],
      users: [
        AppAnalyticsUserModel(userName: 'celta', platform: 'android'),
      ],
      enterprise: 'enterprise-1',
    );

    await datasource.syncAnalytics(
      docId: '2026-08',
      enterpriseName: 'Azuki Store',
      model: model,
    );

    verify(
      () => firebaseStorage.put(
        path: 'analytics/2026-08/informations/azukistore',
        data: any(named: 'data'),
        merge: true,
      ),
    ).called(1);
  });
}
