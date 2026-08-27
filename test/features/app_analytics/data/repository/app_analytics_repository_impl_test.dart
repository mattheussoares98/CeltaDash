import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/app_analytics/data/data.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../enterprises_manager/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockAppAnalyticsDatasource datasource;
  late MockEnterprisesManagerDatasource enterprisesManagerDatasource;
  late AppAnalyticsRepositoryImpl repository;

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    registerFallbackValue(
      const AppAnalyticsModel(
        searchCounts: [],
        users: [],
        enterprise: 'fallback-enterprise',
      ),
    );
    registerFallbackValue(DateTime(2026, 8, 26));
  });

  setUp(() {
    datasource = MockAppAnalyticsDatasource();
    enterprisesManagerDatasource = MockEnterprisesManagerDatasource();
    repository = AppAnalyticsRepositoryImpl(
      datasource: datasource,
      enterprisesManagerDatasource: enterprisesManagerDatasource,
    );
  });

  test('getAnalytics forwards the period and result', () async {
    final period = DateTime(2026, 8);
    final analytics = [AppAnalyticsEntityFactory.makeAppAnalyticsEntity()];
    final models = analytics.map(AppAnalyticsModel.fromEntity).toList();
    when(() => datasource.getAnalytics(period)).thenAnswer((_) async => models);

    expect(await repository.getAnalytics(period), analytics);
    verify(() => datasource.getAnalytics(period)).called(1);
  });

  group('addNewMonthlyAnalytic', () {
    final enterprise = FirebaseEnterpriseModel.fromEntity(
      FirebaseEnterpriseEntity(
        baseUrl: 'http://test',
        enterpriseName: 'Azuki Store',
        bsUser: EntityFactory.makeBsUserEntity(),
        firebaseSubEnterprises: const [],
        firebaseId: 'azuki-id',
      ),
    );

    test(
      'syncs to firebase and clears local storage on first request of the day',
      () async {
        when(
          enterprisesManagerDatasource.loadSelectedEnterprise,
        ).thenAnswer((_) async => enterprise);
        when(
          () => datasource.loadLocalMonthlyAnalytics(enterpriseId: 'azuki-id'),
        ).thenAnswer(
          (_) async => const AppAnalyticsModel(
            searchCounts: [],
            users: [],
            enterprise: 'azuki-id',
          ),
        );
        when(datasource.getLastSyncDate).thenAnswer((_) async => null);
        when(
          () => datasource.syncAnalytics(
            docId: any(named: 'docId'),
            enterpriseName: any(named: 'enterpriseName'),
            model: any(named: 'model'),
          ),
        ).thenAnswer((_) async {});
        when(datasource.clearLocalMonthlyAnalytics).thenAnswer((_) async {});
        when(() => datasource.saveLastSyncDate(any())).thenAnswer((_) async {});

        await repository.addNewMonthlyAnalytic(
          reportType: AppAnalyticsReportType.sales,
          periodType: AppAnalyticsPeriodType.daily,
        );

        verify(
          () => datasource.syncAnalytics(
            docId: any(named: 'docId'),
            enterpriseName: 'Azuki Store',
            model: any(named: 'model'),
          ),
        ).called(1);
        verify(datasource.clearLocalMonthlyAnalytics).called(1);
        verify(() => datasource.saveLastSyncDate(any())).called(1);
      },
    );

    test('buffers locally without syncing if already synced today', () async {
      final today = DateTime.now();
      when(
        enterprisesManagerDatasource.loadSelectedEnterprise,
      ).thenAnswer((_) async => enterprise);
      when(
        () => datasource.loadLocalMonthlyAnalytics(enterpriseId: 'azuki-id'),
      ).thenAnswer(
        (_) async => const AppAnalyticsModel(
          searchCounts: [],
          users: [],
          enterprise: 'azuki-id',
        ),
      );
      when(datasource.getLastSyncDate).thenAnswer((_) async => today);
      when(
        () => datasource.saveLocalMonthlyAnalytics(any()),
      ).thenAnswer((_) async {});

      await repository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.sales,
        periodType: AppAnalyticsPeriodType.daily,
      );

      verifyNever(
        () => datasource.syncAnalytics(
          docId: any(named: 'docId'),
          enterpriseName: any(named: 'enterpriseName'),
          model: any(named: 'model'),
        ),
      );
      verify(() => datasource.saveLocalMonthlyAnalytics(any())).called(1);
    });
  });
}
