// test/features/home/presentation/controllers/products_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../home/mocks/mocks.dart';

void main() {
  late MockSaleStatisticsRepository repository;
  late EcParams ecParams;
  late SaleStatisticsEntity statistic;
  late ProviderContainer container;
  final selectedDate = DateTime(2026, 8, 17);
  const enterpriseId = 10;

  GetSaleStatisticsParams makeParams(ProductsPeriod period) {
    switch (period) {
      case ProductsPeriod.daily:
        final date = DateTime(2026, 8, 17);
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: date,
          endDate: date,
          groupByEnterprise: true,
          groupByDay: true,
          groupByProduct: true,
          topCount: 200,
        );
      case ProductsPeriod.monthly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026, 8),
          endDate: DateTime(2026, 8, 31),
          groupByEnterprise: true,
          groupByMonth: true,
          groupByYear: true,
          groupByProduct: true,
          topCount: 200,
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

  test(
    'loads the selected day statistics for daily period with topCount 200',
    () async {
      final params = makeParams(ProductsPeriod.daily);
      when(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => [statistic]);

      final result = await container.read(
        productsControllerProvider(enterpriseId, ProductsPeriod.daily).future,
      );

      expect(result, [statistic]);
      verify(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).called(1);
    },
  );

  test(
    'loads the entire month statistics for monthly period with topCount 200',
    () async {
      final params = makeParams(ProductsPeriod.monthly);
      when(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => [statistic]);

      final result = await container.read(
        productsControllerProvider(enterpriseId, ProductsPeriod.monthly).future,
      );

      expect(result, [statistic]);
      verify(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).called(1);
    },
  );

  test(
    'invalidation forces the current products query to load again',
    () async {
      final params = makeParams(ProductsPeriod.daily);
      when(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => [statistic]);
      final provider = productsControllerProvider(
        enterpriseId,
        ProductsPeriod.daily,
      );
      await container.read(provider.future);

      container.invalidate(provider);
      await container.read(provider.future);

      expect(container.read(provider).value, [statistic]);
      verify(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).called(2);
    },
  );

  test('preserves repository errors in the controller state', () async {
    final params = makeParams(ProductsPeriod.daily);
    final exception = Exception('failed to load products statistics');
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final provider = productsControllerProvider(
      enterpriseId,
      ProductsPeriod.daily,
    );

    await expectLater(container.read(provider.future), throwsA(exception));

    expect(container.read(provider).error, same(exception));
    expect(container.read(provider).stackTrace, isNotNull);
  });
}
