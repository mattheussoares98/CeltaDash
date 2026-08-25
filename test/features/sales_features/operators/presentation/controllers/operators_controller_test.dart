import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/operators/operators.dart';
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
  late SaleStatisticsEntity statistic;
  late ProviderContainer container;
  final selectedDate = DateTime(2026, 8, 20);
  const enterpriseId = 10;

  GetSaleStatisticsParams makeParams(OperatorsPeriod period) {
    switch (period) {
      case OperatorsPeriod.daily:
        final date = DateTime(2026, 8, 20);
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: date,
          endDate: date,
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByDay: true,
        );
      case OperatorsPeriod.monthly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026, 8),
          endDate: DateTime(2026, 8, 31),
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByMonth: true,
        );
      case OperatorsPeriod.yearly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026),
          endDate: DateTime(2026, 12, 31),
          groupByEnterprise: true,
          groupByCashierOperator: true,
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

  for (final period in OperatorsPeriod.values) {
    test('loads operator statistics for the ${period.name} period', () async {
      final params = makeParams(period);
      when(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => [statistic]);

      final result = await container.read(
        operatorsControllerProvider(enterpriseId, period).future,
      );

      expect(result, [statistic]);
      verify(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).called(1);
    });
  }

  test('invalidation forces the selected operator period to reload', () async {
    final params = makeParams(OperatorsPeriod.daily);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);
    final provider = operatorsControllerProvider(
      enterpriseId,
      OperatorsPeriod.daily,
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
    final params = makeParams(OperatorsPeriod.daily);
    final exception = Exception('failed to load operators');
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final provider = operatorsControllerProvider(
      enterpriseId,
      OperatorsPeriod.daily,
    );

    await expectLater(container.read(provider.future), throwsA(exception));

    expect(container.read(provider).error, same(exception));
    expect(container.read(provider).stackTrace, isNotNull);
  });
}
