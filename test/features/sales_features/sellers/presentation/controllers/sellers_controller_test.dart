// test/features/sellers/presentation/controllers/sellers_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/providers.dart';
import 'package:celta_dash/features/sales_features/sellers/sellers.dart';
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
  final selectedDate = DateTime(2026, 8, 19);
  const enterpriseId = 10;

  GetSaleStatisticsParams makeParams(SellersPeriod period) {
    switch (period) {
      case SellersPeriod.daily:
        final date = DateTime(2026, 8, 19);
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: date,
          endDate: date,
          groupByEnterprise: true,
          groupBySeller: true,
          groupByDay: true,
        );
      case SellersPeriod.monthly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026, 8),
          endDate: DateTime(2026, 8, 31),
          groupByEnterprise: true,
          groupBySeller: true,
          groupByMonth: true,
          groupByYear: true,
        );
      case SellersPeriod.yearly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026),
          endDate: DateTime(2026, 12, 31),
          groupByEnterprise: true,
          groupBySeller: true,
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

  for (final period in SellersPeriod.values) {
    test('loads seller statistics for the ${period.name} period', () async {
      final params = makeParams(period);
      when(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => [statistic]);

      final result = await container.read(
        sellersControllerProvider(enterpriseId, period).future,
      );

      expect(result, [statistic]);
      verify(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).called(1);
    });
  }

  test('invalidation forces the selected seller period to reload', () async {
    final params = makeParams(SellersPeriod.daily);
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => [statistic]);
    final provider = sellersControllerProvider(
      enterpriseId,
      SellersPeriod.daily,
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
    final params = makeParams(SellersPeriod.daily);
    final exception = Exception('failed to load sellers');
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final provider = sellersControllerProvider(
      enterpriseId,
      SellersPeriod.daily,
    );

    await expectLater(container.read(provider.future), throwsA(exception));

    expect(container.read(provider).error, same(exception));
    expect(container.read(provider).stackTrace, isNotNull);
  });
}
