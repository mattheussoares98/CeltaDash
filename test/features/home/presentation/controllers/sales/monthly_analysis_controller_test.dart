import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';
import '../../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../mocks/mocks.dart';

void main() {
  late MockSaleStatisticsRepository repository;
  late EcParams ecParams;
  final now = DateTime(2026, 8, 17, 15, 30);
  const enterpriseId = 10;

  final params = GetSaleStatisticsParams(
    startDate: DateTime(2026, 8),
    endDate: DateTime(2026, 8, 17, 15, 30),
    groupByEnterprise: true,
    groupByDay: true,
    enterpriseIds: const [enterpriseId],
  );

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      activeEcParamsStateControllerProvider.overrideWith(
        () => FakeActiveEcParams(ecParams),
      ),
      resumeCurrentDateProvider.overrideWithValue(now),
      homeControllerProvider.overrideWith(
        () => FakeHomeController(
          HomeState.initial(
            appMode: AppMode.sales,
          ).copyWith(selectedDate: now, selectedEnterpriseId: enterpriseId),
        ),
      ),
      saleStatisticsRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
  });

  test('loads, groups, and sorts the selected month sales by day', () async {
    final base = EntityFactory.makeSaleStatisticEntity();
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer(
      (_) async => [
        base.copyWith(Date: DateTime(2026, 8, 2), LiquidValue: 40),
        base.copyWith(Date: DateTime(2026, 8), LiquidValue: 30),
        base.copyWith(Date: DateTime(2026, 8, 2), LiquidValue: 60),
      ],
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      monthlyAnalysisControllerProvider(enterpriseId).future,
    );

    expect(result.totalSales, 130);
    expect(result.days.map((day) => day.date), [
      DateTime(2026, 8),
      DateTime(2026, 8, 2),
    ]);
    expect(result.days.map((day) => day.value), [30, 100]);
    expect(result.averageDailySale, 65);
    expect(result.bestDay?.date, DateTime(2026, 8, 2));
    expect(result.worstDay?.date, DateTime(2026, 8));
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('excludes the incomplete current day when three days exist', () async {
    final base = EntityFactory.makeSaleStatisticEntity();
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer(
      (_) async => [
        base.copyWith(Date: DateTime(2026, 8), LiquidValue: 10),
        base.copyWith(Date: DateTime(2026, 8, 2), LiquidValue: 20),
        base.copyWith(Date: now, LiquidValue: 30),
      ],
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      monthlyAnalysisControllerProvider(enterpriseId).future,
    );

    expect(result.totalSales, 60);
    expect(result.days.map((day) => day.date), [
      DateTime(2026, 8),
      DateTime(2026, 8, 2),
    ]);
  });

  test('forwards repository failures as controller errors', () async {
    final exception = Exception('statistics unavailable');
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = monthlyAnalysisControllerProvider(enterpriseId);
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);

    await expectLater(container.read(provider.future), throwsA(exception));
  });
}
