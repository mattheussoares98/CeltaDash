import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';
import '../../../../app_analytics/mocks/mocks.dart';
import '../../../../buy_movement/mocks/mocks.dart';
import '../../../mocks/mocks.dart';

void main() {
  late MockBuyMovementRepository repository;
  late MockAppAnalyticsRepository analyticsRepository;
  late ProviderContainer container;
  late EcParams ecParams;
  late List<HomeEnterpriseEntity> enterprises;
  final selectedDate = DateTime(2026, 8, 17);
  const selectedEnterpriseId = 10;

  SearchBuyMovementDataParamsEntity makeParams() {
    return BuyMovementEntityFactory.makeSearchParams(
      enterpriseCodes: const [10, 20],
      startDate: DateTime(2026, 8, 17),
      endDate: DateTime(2026, 8, 17),
      periodGrouping: BuyMovementPeriodGrouping.day,
      groupByEnterprise: true,
      groupByProduct: false,
      groupBySupplier: false,
    );
  }

  ProviderContainer makeContainer(List<HomeEnterpriseEntity> values) {
    return ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => MutableActiveEcParams(ecParams),
        ),
        homeControllerProvider.overrideWith(
          () => FakeHomeController(
            HomeState.initial(appMode: AppMode.sales).copyWith(
              selectedEnterpriseId: selectedEnterpriseId,
              selectedDate: selectedDate,
            ),
          ),
        ),
        enterprisesControllerProvider.overrideWith(
          () => FakeEnterprisesController(values),
        ),
        buyMovementRepositoryProvider.overrideWithValue(repository),
        appAnalyticsRepositoryProvider.overrideWithValue(analyticsRepository),
      ],
    );
  }

  setUp(() {
    repository = MockBuyMovementRepository();
    analyticsRepository = MockAppAnalyticsRepository();
    ecParams = EntityFactory.makeEcParams();
    enterprises = [
      HomeEntityFactory.makeHomeEnterpriseEntity(id: 10, enabled: true),
      HomeEntityFactory.makeHomeEnterpriseEntity(id: 20, enabled: true),
      HomeEntityFactory.makeHomeEnterpriseEntity(id: 30, enabled: false),
    ];
    container = makeContainer(enterprises);
  });

  tearDown(() => container.dispose());

  test('loads and sorts one daily total per enabled enterprise', () async {
    final params = makeParams();
    final response = BuyMovementEntityFactory.makeResponseEntity(
      searchParameters: params,
      results: [
        BuyMovementEntityFactory.makeDataRowEntity(
          enterpriseCode: 10,
          withProduct: false,
          withSupplier: false,
          totalValue: 120,
        ),
        BuyMovementEntityFactory.makeDataRowEntity(
          enterpriseCode: 20,
          withProduct: false,
          withSupplier: false,
          totalValue: 80,
        ),
        BuyMovementEntityFactory.makeDataRowEntity(
          enterpriseCode: 20,
          withProduct: false,
          withSupplier: false,
          totalValue: 20,
        ),
      ],
    );
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => response);
    when(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementGroupOfStores,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    ).thenAnswer((_) async {});

    final result = await container.read(
      buyMovementGroupOfStoresControllerProvider(selectedEnterpriseId).future,
    );

    expect(result.enterprises.map((enterprise) => enterprise.id), [10, 20]);
    expect(result.enterprises.map((enterprise) => enterprise.totalValue), [
      120,
      100,
    ]);
    expect(result.enterprises.first.name, isNotEmpty);
    verify(
      () => repository.getData(params: params, ecParams: ecParams),
    ).called(1);
    verify(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementGroupOfStores,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    ).called(1);
  });

  test('does not request group data for only one enabled enterprise', () async {
    final singleEnterpriseContainer = makeContainer([enterprises.first]);
    addTearDown(singleEnterpriseContainer.dispose);

    final result = await singleEnterpriseContainer.read(
      buyMovementGroupOfStoresControllerProvider(selectedEnterpriseId).future,
    );

    expect(result.enterprises, isEmpty);
    verifyZeroInteractions(repository);
    verifyZeroInteractions(analyticsRepository);
  });

  test('does not record analytics when loading fails', () async {
    final params = makeParams();
    final exception = Exception('failed to load group purchases');
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenThrow(exception);

    await expectLater(
      container.read(
        buyMovementGroupOfStoresControllerProvider(selectedEnterpriseId).future,
      ),
      throwsA(same(exception)),
    );

    verifyNever(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementGroupOfStores,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    );
  });
}
