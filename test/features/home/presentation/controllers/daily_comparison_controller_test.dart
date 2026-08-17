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
  late DateTime now;
  late DateTime selectedDate;
  const enterpriseId = 10;

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
          ).copyWith(selectedDate: selectedDate),
        ),
      ),
      saleStatisticsRepositoryProvider.overrideWithValue(repository),
    ],
  );

  GetSaleStatisticsParams makeParams(DateTime date, {required bool isToday}) =>
      GetSaleStatisticsParams(
        startDate: DateTime(date.year, date.month, date.day),
        endDate: DateTime(
          date.year,
          date.month,
          date.day,
          isToday ? now.hour : 23,
          isToday ? now.minute : 59,
        ),
        groupByEnterprise: true,
        groupByDay: true,
        enterpriseIds: const [enterpriseId],
      );

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
    now = DateTime(2026, 8, 14, 15, 42);
    selectedDate = DateTime(2026, 8, 14);
  });

  test('loads today and the same day of the previous month', () async {
    final comparisonDate = DateTime(2026, 7, 14);
    final selectedParams = makeParams(selectedDate, isToday: true);
    final comparisonParams = makeParams(comparisonDate, isToday: true);
    final selectedStatistic = EntityFactory.makeSaleStatisticEntity().copyWith(
      LiquidValue: 300,
      QuantitySales: 3,
    );
    final comparisonStatistic = EntityFactory.makeSaleStatisticEntity()
        .copyWith(LiquidValue: 200, QuantitySales: 4);
    when(
      () => repository.getSaleStatistics(
        params: selectedParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => [selectedStatistic]);
    when(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => [comparisonStatistic]);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      dailyComparisonControllerProvider(enterpriseId).future,
    );

    expect(result.selectedLiquidValue, 300);
    expect(result.comparisonLiquidValue, 200);
    expect(result.selectedCustomers, 3);
    expect(result.comparisonCustomers, 4);
    expect(result.percentageDifference, 50);
    expect(result.selectedAverageTicket, 100);
    expect(result.comparisonAverageTicket, 50);
    verify(
      () => repository.getSaleStatistics(
        params: selectedParams,
        ecParams: ecParams,
      ),
    ).called(1);
    verify(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).called(1);
  });

  test(
    'uses the end of the day when the selected date is in the past',
    () async {
      selectedDate = DateTime(2026, 8, 10);
      final comparisonDate = DateTime(2026, 7, 10);
      final selectedParams = makeParams(selectedDate, isToday: false);
      final comparisonParams = makeParams(comparisonDate, isToday: false);
      when(
        () => repository.getSaleStatistics(
          params: selectedParams,
          ecParams: ecParams,
        ),
      ).thenAnswer((_) async => []);
      when(
        () => repository.getSaleStatistics(
          params: comparisonParams,
          ecParams: ecParams,
        ),
      ).thenAnswer((_) async => []);
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(
        dailyComparisonControllerProvider(enterpriseId).future,
      );

      verify(
        () => repository.getSaleStatistics(
          params: selectedParams,
          ecParams: ecParams,
        ),
      ).called(1);
      verify(
        () => repository.getSaleStatistics(
          params: comparisonParams,
          ecParams: ecParams,
        ),
      ).called(1);
    },
  );

  test('returns zero values when both periods have no sales', () async {
    final comparisonDate = DateTime(2026, 7, 14);
    final selectedParams = makeParams(selectedDate, isToday: true);
    final comparisonParams = makeParams(comparisonDate, isToday: true);
    when(
      () => repository.getSaleStatistics(
        params: selectedParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    when(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      dailyComparisonControllerProvider(enterpriseId).future,
    );

    expect(result.selectedLiquidValue, 0);
    expect(result.comparisonLiquidValue, 0);
    expect(result.selectedCustomers, 0);
    expect(result.comparisonCustomers, 0);
    expect(result.percentageDifference, 0);
    expect(result.selectedAverageTicket, 0);
    expect(result.comparisonAverageTicket, 0);
  });

  test('exposes repository errors', () async {
    final comparisonDate = DateTime(2026, 7, 14);
    final selectedParams = makeParams(selectedDate, isToday: true);
    final comparisonParams = makeParams(comparisonDate, isToday: true);
    final error = Exception('Falha ao carregar a comparação diária.');
    when(
      () => repository.getSaleStatistics(
        params: selectedParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => throw error);
    when(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = dailyComparisonControllerProvider(enterpriseId);
    container.listen(provider, (_, _) {});

    expect(container.read(provider.future), throwsA(same(error)));
  });
}
