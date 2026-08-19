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
import '../../mocks/mocks.dart';

void main() {
  late MockSaleStatisticsRepository repository;
  late EcParams ecParams;
  final selectedDate = DateTime(2026, 8, 17);
  const enterpriseId = 10;

  final params = GetSaleStatisticsParams(
    startDate: selectedDate,
    endDate: DateTime(2026, 8, 17, 23, 59, 59),
    groupByEnterprise: true,
    groupByDay: true,
  );

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      activeEcParamsStateControllerProvider.overrideWith(
        () => FakeActiveEcParams(ecParams),
      ),
      homeControllerProvider.overrideWith(
        () => FakeHomeController(
          HomeState.initial(appMode: AppMode.sales).copyWith(
            selectedDate: selectedDate,
            selectedEnterpriseId: enterpriseId,
          ),
        ),
      ),
      saleStatisticsRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
  });

  test('groups and sorts the selected day sales by enterprise', () async {
    final base = EntityFactory.makeSaleStatisticEntity();
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenAnswer(
      (_) async => [
        base.copyWith(
          EnterpriseId: 1,
          EnterprisePersonalizedCode: '001',
          EnterpriseFantasyName: 'Downtown',
          LiquidValue: 30,
        ),
        base.copyWith(
          EnterpriseId: 2,
          EnterprisePersonalizedCode: '002',
          EnterpriseFantasyName: 'Mall',
          LiquidValue: 100,
        ),
        base.copyWith(
          EnterpriseId: 1,
          EnterprisePersonalizedCode: '001',
          EnterpriseFantasyName: 'Downtown',
          LiquidValue: 20,
        ),
      ],
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      groupOfStoresControllerProvider(enterpriseId).future,
    );

    expect(result.hasMultipleEnterprises, isTrue);
    expect(result.enterprises.map((enterprise) => enterprise.id), [2, 1]);
    expect(result.enterprises.map((enterprise) => enterprise.name), [
      '002-Mall',
      '001-Downtown',
    ]);
    expect(result.enterprises.map((enterprise) => enterprise.liquidValue), [
      100,
      50,
    ]);
    verify(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('forwards repository failures as controller errors', () async {
    final exception = Exception('statistics unavailable');
    when(
      () => repository.getSaleStatistics(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = groupOfStoresControllerProvider(enterpriseId);
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);

    await expectLater(container.read(provider.future), throwsA(exception));
  });
}
