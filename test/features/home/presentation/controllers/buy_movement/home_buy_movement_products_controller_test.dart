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
  late BuyMovementDataResponseEntity response;
  final selectedDate = DateTime(2026, 8, 17);
  const enterpriseId = 10;

  SearchBuyMovementDataParamsEntity makeParams({
    String? productName,
    int topCount = 10,
  }) {
    return BuyMovementEntityFactory.makeSearchParams(
      enterpriseCodes: const [enterpriseId],
      startDate: DateTime(2026, 8),
      endDate: DateTime(2026, 8, 31),
      annulPeriodGrouping: true,
      groupByProduct: true,
      groupBySupplier: false,
      productName: productName,
      topCount: topCount,
    );
  }

  void stubAnalytics() {
    when(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementProducts,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    ).thenAnswer((_) async {});
  }

  setUp(() {
    repository = MockBuyMovementRepository();
    analyticsRepository = MockAppAnalyticsRepository();
    ecParams = EntityFactory.makeEcParams();
    response = BuyMovementEntityFactory.makeResponseEntity();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => MutableActiveEcParams(ecParams),
        ),
        homeControllerProvider.overrideWith(
          () => FakeHomeController(
            HomeState.initial(appMode: AppMode.sales).copyWith(
              selectedEnterpriseId: enterpriseId,
              selectedDate: selectedDate,
            ),
          ),
        ),
        buyMovementRepositoryProvider.overrideWithValue(repository),
        appAnalyticsRepositoryProvider.overrideWithValue(analyticsRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('loads the selected month grouped only by product', () async {
    final params = makeParams();
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => response);
    stubAnalytics();

    final result = await container.read(
      homeBuyMovementProductsControllerProvider(
        enterpriseId,
        HomeBuyMovementPeriod.daily,
      ).future,
    );

    expect(result, response.results);
    verify(
      () => repository.getData(params: params, ecParams: ecParams),
    ).called(1);
    verify(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementProducts,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    ).called(1);
  });

  test('reloads only the products slot when filters change', () async {
    final initialParams = makeParams();
    final filteredParams = makeParams(productName: 'coffee', topCount: 25);
    when(
      () => repository.getData(params: initialParams, ecParams: ecParams),
    ).thenAnswer((_) async => response);
    when(
      () => repository.getData(params: filteredParams, ecParams: ecParams),
    ).thenAnswer((_) async => response);
    stubAnalytics();
    final provider = homeBuyMovementProductsControllerProvider(
      enterpriseId,
      HomeBuyMovementPeriod.daily,
    );
    await container.read(provider.future);

    final filters = container.read(
      homeBuyMovementProductsFilterControllerProvider.notifier,
    );
    filters.setProductName(' coffee ');
    filters.setTopCount(25);
    await container.read(provider.future);

    verify(
      () => repository.getData(params: initialParams, ecParams: ecParams),
    ).called(1);
    verify(
      () => repository.getData(params: filteredParams, ecParams: ecParams),
    ).called(1);
  });

  test('does not record analytics when loading fails', () async {
    final params = makeParams();
    final exception = Exception('failed to load buy movement products');
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenThrow(exception);

    await expectLater(
      container.read(
        homeBuyMovementProductsControllerProvider(
          enterpriseId,
          HomeBuyMovementPeriod.daily,
        ).future,
      ),
      throwsA(same(exception)),
    );

    verifyNever(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovementProducts,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    );
  });
}
