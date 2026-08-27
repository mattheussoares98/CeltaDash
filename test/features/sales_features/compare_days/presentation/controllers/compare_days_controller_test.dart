import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:celta_dash/features/sales_features/compare_days/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/compare_days/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';
import '../../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../../home/mocks/mocks.dart';

void main() {
  late MockSaleStatisticsRepository repository;
  late EcParams ecParams;
  final now = DateTime(2026, 8, 21, 14, 30);
  const enterpriseId = 10;

  final firstDayParams = GetSaleStatisticsParams(
    startDate: DateTime(2026, 8, 20),
    endDate: DateTime(2026, 8, 20),
    enterpriseIds: const [enterpriseId],
    groupByEnterprise: true,
    groupByHour: true,
  );
  final secondDayParams = GetSaleStatisticsParams(
    startDate: DateTime(2026, 8, 21),
    endDate: DateTime(2026, 8, 21),
    enterpriseIds: const [enterpriseId],
    groupByEnterprise: true,
    groupByHour: true,
  );

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      resumeCurrentDateProvider.overrideWithValue(now),
      activeEcParamsStateControllerProvider.overrideWith(
        () => FakeActiveEcParams(ecParams),
      ),
      saleStatisticsRepositoryProvider.overrideWithValue(repository),
    ],
  );

  void stubSuccessfulRequests({
    required SaleStatisticsEntity firstStatistic,
    required SaleStatisticsEntity secondStatistic,
  }) {
    when(
      () => repository.getSaleStatistics(
        params: firstDayParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => [firstStatistic]);
    when(
      () => repository.getSaleStatistics(
        params: secondDayParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => [secondStatistic]);
  }

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
  });

  test('loads both selected days with hourly grouping', () async {
    final firstStatistic = EntityFactory.makeSaleStatisticEntity().copyWith(
      LiquidValue: 100,
    );
    final secondStatistic = EntityFactory.makeSaleStatisticEntity().copyWith(
      LiquidValue: 80,
    );
    stubSuccessfulRequests(
      firstStatistic: firstStatistic,
      secondStatistic: secondStatistic,
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      compareDaysControllerProvider(enterpriseId).future,
    );

    expect(
      result,
      CompareDaysState(
        firstDayStatistics: [firstStatistic],
        secondDayStatistics: [secondStatistic],
      ),
    );
    verify(
      () => repository.getSaleStatistics(
        params: firstDayParams,
        ecParams: ecParams,
      ),
    ).called(1);
    verify(
      () => repository.getSaleStatistics(
        params: secondDayParams,
        ecParams: ecParams,
      ),
    ).called(1);
  });

  test('refresh reloads both selected days', () async {
    final firstStatistic = EntityFactory.makeSaleStatisticEntity();
    final secondStatistic = EntityFactory.makeSaleStatisticEntity();
    stubSuccessfulRequests(
      firstStatistic: firstStatistic,
      secondStatistic: secondStatistic,
    );
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = compareDaysControllerProvider(enterpriseId);
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);
    await container.read(provider.future);

    await container.read(provider.notifier).refresh();

    expect(container.read(provider).hasValue, isTrue);
    verify(
      () => repository.getSaleStatistics(
        params: firstDayParams,
        ecParams: ecParams,
      ),
    ).called(2);
    verify(
      () => repository.getSaleStatistics(
        params: secondDayParams,
        ecParams: ecParams,
      ),
    ).called(2);
  });

  test('forwards a repository failure as a controller error', () async {
    final exception = Exception('statistics unavailable');
    when(
      () => repository.getSaleStatistics(
        params: firstDayParams,
        ecParams: ecParams,
      ),
    ).thenThrow(exception);
    when(
      () => repository.getSaleStatistics(
        params: secondDayParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = compareDaysControllerProvider(enterpriseId);
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);

    await expectLater(container.read(provider.future), throwsA(exception));
    expect(container.read(provider).hasError, isTrue);
  });
}
