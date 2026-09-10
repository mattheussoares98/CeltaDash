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

  SearchBuyMovementDataParamsEntity makeParams(HomeBuyMovementPeriod period) {
    final (startDate, endDate) = switch (period) {
      HomeBuyMovementPeriod.hourly => (
        DateTime(2026, 8, 17),
        DateTime(2026, 8, 17),
      ),
      HomeBuyMovementPeriod.daily => (DateTime(2026, 8), DateTime(2026, 8, 31)),
      HomeBuyMovementPeriod.monthly => (DateTime(2026), DateTime(2026, 12, 31)),
      HomeBuyMovementPeriod.yearly => (DateTime(2024), DateTime(2026, 12, 31)),
    };
    return BuyMovementEntityFactory.makeSearchParams(
      enterpriseCodes: const [enterpriseId],
      startDate: startDate,
      endDate: endDate,
      periodGrouping: period.periodGrouping,
      groupByProduct: false,
      groupBySupplier: false,
    );
  }

  AppAnalyticsPeriodType analyticsPeriod(HomeBuyMovementPeriod period) {
    return switch (period) {
      HomeBuyMovementPeriod.hourly => AppAnalyticsPeriodType.hourly,
      HomeBuyMovementPeriod.daily => AppAnalyticsPeriodType.daily,
      HomeBuyMovementPeriod.monthly => AppAnalyticsPeriodType.monthly,
      HomeBuyMovementPeriod.yearly => AppAnalyticsPeriodType.yearly,
    };
  }

  void stubAnalytics(HomeBuyMovementPeriod period) {
    when(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovements,
        periodType: analyticsPeriod(period),
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

  for (final period in HomeBuyMovementPeriod.values) {
    test(
      'loads the bounded ${period.name} query and aggregates its total',
      () async {
        final params = makeParams(period);
        when(
          () => repository.getData(params: params, ecParams: ecParams),
        ).thenAnswer((_) async => response);
        stubAnalytics(period);

        final result = await container.read(
          homeBuyMovementControllerProvider(enterpriseId, period).future,
        );

        expect(result.rows, response.results);
        expect(
          result.totalValue,
          response.results.fold<num>(0, (total, row) => total + row.totalValue),
        );
        verify(
          () => repository.getData(params: params, ecParams: ecParams),
        ).called(1);
        verify(
          () => analyticsRepository.addNewMonthlyAnalytic(
            reportType: AppAnalyticsReportType.buyMovements,
            periodType: analyticsPeriod(period),
          ),
        ).called(1);
      },
    );
  }

  test('does not record analytics when loading fails', () async {
    final params = makeParams(HomeBuyMovementPeriod.daily);
    final exception = Exception('failed to load buy movements');
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenThrow(exception);

    await expectLater(
      container.read(
        homeBuyMovementControllerProvider(
          enterpriseId,
          HomeBuyMovementPeriod.daily,
        ).future,
      ),
      throwsA(same(exception)),
    );

    verifyNever(
      () => analyticsRepository.addNewMonthlyAnalytic(
        reportType: AppAnalyticsReportType.buyMovements,
        periodType: AppAnalyticsPeriodType.daily,
      ),
    );
  });
}
