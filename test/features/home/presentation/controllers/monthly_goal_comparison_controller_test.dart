import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:celta_dash/features/home/providers.dart';
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
  late MockHomeRepository homeRepository;
  late EcParams ecParams;
  late FirebaseEnterpriseEntity activeEnterprise;
  late MonthlyGoalEntity? customGoal;
  late DateTime selectedDate;
  const enterpriseId = 10;

  GetSaleStatisticsParams makeParams(DateTime startDate, DateTime endDate) =>
      GetSaleStatisticsParams(
        startDate: startDate,
        endDate: endDate,
        groupByEnterprise: true,
        groupByYear: true,
        groupByMonth: true,
        enterpriseIds: const [enterpriseId],
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
      dailyComparisonControllerProvider(enterpriseId).overrideWith(
        () => FakeDailyComparisonController(
          DailyComparisonState(
            selectedDate: selectedDate,
            comparisonDate: DateTime(
              selectedDate.year,
              selectedDate.month - 1,
              selectedDate.day,
            ),
            selectedLiquidValue: 250,
            comparisonLiquidValue: 200,
            selectedCustomers: 5,
            comparisonCustomers: 4,
          ),
        ),
      ),
      saleStatisticsRepositoryProvider.overrideWithValue(repository),
      homeRepositoryProvider.overrideWithValue(homeRepository),
    ],
  );

  setUp(() {
    repository = MockSaleStatisticsRepository();
    homeRepository = MockHomeRepository();
    ecParams = EntityFactory.makeEcParams();
    selectedDate = DateTime(2026, 8, 14);
    activeEnterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    customGoal = null;
    when(
      () => homeRepository.loadActiveEnterprise(),
    ).thenAnswer((_) async => activeEnterprise);
    when(
      () => homeRepository.getMonthlyGoal(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
        enterpriseId: enterpriseId,
        month: selectedDate,
      ),
    ).thenAnswer((_) async => customGoal);
  });

  test('calculates monthly and daily goals from the previous year', () async {
    final currentParams = makeParams(DateTime(2026, 8), DateTime(2026, 9, 0));
    final comparisonParams = makeParams(
      DateTime(2025, 8),
      DateTime(2025, 9, 0),
    );
    when(
      () => repository.getSaleStatistics(
        params: currentParams,
        ecParams: ecParams,
      ),
    ).thenAnswer(
      (_) async => [
        EntityFactory.makeSaleStatisticEntity().copyWith(LiquidValue: 800),
      ],
    );
    when(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).thenAnswer(
      (_) async => [
        EntityFactory.makeSaleStatisticEntity().copyWith(LiquidValue: 1000),
      ],
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      monthlyGoalComparisonControllerProvider(enterpriseId).future,
    );

    expect(result.currentMonthLiquidValue, 800);
    expect(result.comparisonLiquidValue, 1000);
    expect(result.selectedDayLiquidValue, 250);
    expect(result.monthlyGoal, 1050);
    expect(result.dailyGoal, closeTo(1050 / 31, 0.001));
  });

  test('uses the previous month when the previous year has no sales', () async {
    final currentParams = makeParams(DateTime(2026, 8), DateTime(2026, 9, 0));
    final previousYearParams = makeParams(
      DateTime(2025, 8),
      DateTime(2025, 9, 0),
    );
    final previousMonthParams = makeParams(
      DateTime(2026, 7),
      DateTime(2026, 8, 0),
    );
    when(
      () => repository.getSaleStatistics(
        params: currentParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    when(
      () => repository.getSaleStatistics(
        params: previousYearParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    when(
      () => repository.getSaleStatistics(
        params: previousMonthParams,
        ecParams: ecParams,
      ),
    ).thenAnswer(
      (_) async => [
        EntityFactory.makeSaleStatisticEntity().copyWith(LiquidValue: 500),
      ],
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      monthlyGoalComparisonControllerProvider(enterpriseId).future,
    );

    expect(result.comparisonDate, DateTime(2026, 7, 31));
    expect(result.monthlyGoal, 525);
    verify(
      () => repository.getSaleStatistics(
        params: previousMonthParams,
        ecParams: ecParams,
      ),
    ).called(1);
  });

  test('uses a saved monthly goal when one exists', () async {
    final currentParams = makeParams(DateTime(2026, 8), DateTime(2026, 9, 0));
    final comparisonParams = makeParams(
      DateTime(2025, 8),
      DateTime(2025, 9, 0),
    );
    customGoal = MonthlyGoalEntity(
      enterpriseId: enterpriseId,
      month: selectedDate,
      value: 2000,
      userName: activeEnterprise.bsUser!.name!,
    );
    when(
      () => repository.getSaleStatistics(
        params: currentParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    when(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).thenAnswer(
      (_) async => [
        EntityFactory.makeSaleStatisticEntity().copyWith(LiquidValue: 1000),
      ],
    );
    final container = makeContainer();
    addTearDown(container.dispose);

    final result = await container.read(
      monthlyGoalComparisonControllerProvider(enterpriseId).future,
    );

    expect(result.monthlyGoal, 2000);
    expect(result.dailyGoal, closeTo(2000 / 31, 0.001));
  });

  test('updateMonthlyGoal persists and exposes the new goal', () async {
    final currentParams = makeParams(DateTime(2026, 8), DateTime(2026, 9, 0));
    final comparisonParams = makeParams(
      DateTime(2025, 8),
      DateTime(2025, 9, 0),
    );
    when(
      () => repository.getSaleStatistics(
        params: currentParams,
        ecParams: ecParams,
      ),
    ).thenAnswer((_) async => []);
    when(
      () => repository.getSaleStatistics(
        params: comparisonParams,
        ecParams: ecParams,
      ),
    ).thenAnswer(
      (_) async => [
        EntityFactory.makeSaleStatisticEntity().copyWith(LiquidValue: 1000),
      ],
    );
    const newGoal = 2500.0;
    final expectedGoal = MonthlyGoalEntity(
      enterpriseId: enterpriseId,
      month: selectedDate,
      value: newGoal,
      userName: activeEnterprise.bsUser!.name!,
    );
    when(
      () => homeRepository.saveMonthlyGoal(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
        goal: expectedGoal,
      ),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = monthlyGoalComparisonControllerProvider(enterpriseId);
    await container.read(provider.future);

    await container.read(provider.notifier).updateMonthlyGoal(newGoal);

    expect(container.read(provider).requireValue.monthlyGoal, newGoal);
    verify(
      () => homeRepository.saveMonthlyGoal(
        firebaseEnterpriseId: activeEnterprise.firebaseId!,
        goal: expectedGoal,
      ),
    ).called(1);
  });

  test(
    'updateMonthlyGoal preserves the current goal when saving fails',
    () async {
      final currentParams = makeParams(DateTime(2026, 8), DateTime(2026, 9, 0));
      final comparisonParams = makeParams(
        DateTime(2025, 8),
        DateTime(2025, 9, 0),
      );
      when(
        () => repository.getSaleStatistics(
          params: currentParams,
          ecParams: ecParams,
        ),
      ).thenAnswer((_) async => []);
      when(
        () => repository.getSaleStatistics(
          params: comparisonParams,
          ecParams: ecParams,
        ),
      ).thenAnswer(
        (_) async => [
          EntityFactory.makeSaleStatisticEntity().copyWith(LiquidValue: 1000),
        ],
      );
      const newGoal = 2500.0;
      final expectedGoal = MonthlyGoalEntity(
        enterpriseId: enterpriseId,
        month: selectedDate,
        value: newGoal,
        userName: activeEnterprise.bsUser!.name!,
      );
      final error = Exception('Falha ao salvar a meta.');
      when(
        () => homeRepository.saveMonthlyGoal(
          firebaseEnterpriseId: activeEnterprise.firebaseId!,
          goal: expectedGoal,
        ),
      ).thenThrow(error);
      final container = makeContainer();
      addTearDown(container.dispose);
      final provider = monthlyGoalComparisonControllerProvider(enterpriseId);
      final previous = await container.read(provider.future);

      await expectLater(
        container.read(provider.notifier).updateMonthlyGoal(newGoal),
        throwsA(same(error)),
      );
      expect(container.read(provider).requireValue, previous);
    },
  );

  test('exposes sale statistics errors', () async {
    final currentParams = makeParams(DateTime(2026, 8), DateTime(2026, 9, 0));
    final comparisonParams = makeParams(
      DateTime(2025, 8),
      DateTime(2025, 9, 0),
    );
    final error = Exception('Falha ao carregar as metas.');
    when(
      () => repository.getSaleStatistics(
        params: currentParams,
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
    final provider = monthlyGoalComparisonControllerProvider(enterpriseId);
    container.listen(provider, (_, _) {});

    expect(container.read(provider.future), throwsA(same(error)));
  });
}
