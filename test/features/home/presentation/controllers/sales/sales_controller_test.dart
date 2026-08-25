// test/features/home/presentation/controllers/sales_controller_test.dart
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
  late SaleStatisticsEntity statistic;
  late ProviderContainer container;
  final selectedDate = DateTime(2026, 8, 17);
  const enterpriseId = 10;

  GetSaleStatisticsParams makeParams(HomeSalesPeriod period) {
    switch (period) {
      case HomeSalesPeriod.hourly:
        final date = DateTime(2026, 8, 17);
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: date,
          endDate: date,
          groupByEnterprise: true,
          groupByHour: true,
        );
      case HomeSalesPeriod.daily:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026, 8),
          endDate: DateTime(2026, 8, 31),
          groupByEnterprise: true,
          groupByDay: true,
        );
      case HomeSalesPeriod.monthly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026),
          endDate: DateTime(2026, 12, 31),
          groupByEnterprise: true,
          groupByMonth: true,
          groupByYear: true,
        );
      case HomeSalesPeriod.yearly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2024),
          endDate: DateTime(2026, 12, 31),
          groupByEnterprise: true,
          groupByYear: true,
        );
    }
  }

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      activeEcParamsStateControllerProvider.overrideWith(
        () => FakeActiveEcParams(ecParams),
      ),
      homeControllerProvider.overrideWith(
        () => FakeHomeController(
          HomeState.initial(appMode: AppMode.sales).copyWith(
            selectedEnterpriseId: enterpriseId,
            selectedDate: selectedDate,
          ),
        ),
      ),
      saleStatisticsRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
    statistic = EntityFactory.makeSaleStatisticEntity(
      enterpriseId: enterpriseId,
    );
    container = makeContainer();
  });

  tearDown(() => container.dispose());

  test('loads the selected day statistics for hourly period', () async {
    final params = makeParams(HomeSalesPeriod.hourly);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);

    final result = await container.read(
      homeSalesControllerProvider(enterpriseId, HomeSalesPeriod.hourly).future,
    );

    expect(result, [statistic]);
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('loads the entire month statistics for daily period', () async {
    final params = makeParams(HomeSalesPeriod.daily);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);

    final result = await container.read(
      homeSalesControllerProvider(enterpriseId, HomeSalesPeriod.daily).future,
    );

    expect(result, [statistic]);
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('loads the entire year statistics for monthly period', () async {
    final params = makeParams(HomeSalesPeriod.monthly);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);

    final result = await container.read(
      homeSalesControllerProvider(enterpriseId, HomeSalesPeriod.monthly).future,
    );

    expect(result, [statistic]);
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('loads the past 3 years statistics for yearly period', () async {
    final params = makeParams(HomeSalesPeriod.yearly);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);

    final result = await container.read(
      homeSalesControllerProvider(enterpriseId, HomeSalesPeriod.yearly).future,
    );

    expect(result, [statistic]);
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('invalidation forces the current sales query to load again', () async {
    final params = makeParams(HomeSalesPeriod.hourly);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);
    final provider = homeSalesControllerProvider(
      enterpriseId,
      HomeSalesPeriod.hourly,
    );
    await container.read(provider.future);

    container.invalidate(provider);
    await container.read(provider.future);

    expect(container.read(provider).value, [statistic]);
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(2);
  });

  test('preserves repository errors in the controller state', () async {
    final params = makeParams(HomeSalesPeriod.hourly);
    final exception = Exception('failed to load sales');
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final provider = homeSalesControllerProvider(
      enterpriseId,
      HomeSalesPeriod.hourly,
    );

    await expectLater(container.read(provider.future), throwsA(exception));

    expect(container.read(provider).error, same(exception));
    expect(container.read(provider).stackTrace, isNotNull);
  });
}
