// test/features/home/presentation/controllers/home_financial_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/domain/repository/repository.dart';
import 'package:celta_dash/features/financial_titles/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../home/mocks/mocks.dart';

class MockFinancialTitlesRepository extends Mock
    implements IFinancialTitlesRepository {}

void main() {
  late MockFinancialTitlesRepository repository;
  late EcParams ecParams;
  late FinancialTitleDataResponseEntity responseEntity;
  late ProviderContainer container;
  final selectedDate = DateTime(2026, 8, 17);
  const enterpriseId = 10;

  SearchFinancialTitleDataParams makeParams(HomeFinancialPeriod period) {
    switch (period) {
      case HomeFinancialPeriod.daily:
        return SearchFinancialTitleDataParams(
          enterpriseCodes: const [enterpriseId],
          startDate: DateTime(2026, 8),
          endDate: DateTime(2026, 8, 31),
          periodGrouping: FinancialTitlePeriodGrouping.day,
        );
      case HomeFinancialPeriod.monthly:
        return SearchFinancialTitleDataParams(
          enterpriseCodes: const [enterpriseId],
          startDate: DateTime(2026),
          endDate: DateTime(2026, 12, 31),
          periodGrouping: FinancialTitlePeriodGrouping.month,
        );
      case HomeFinancialPeriod.yearly:
        return SearchFinancialTitleDataParams(
          enterpriseCodes: const [enterpriseId],
          startDate: DateTime(2024),
          endDate: DateTime(2026, 12, 31),
          periodGrouping: FinancialTitlePeriodGrouping.year,
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
          HomeState.initial(appMode: AppMode.financialTitles).copyWith(
            selectedEnterpriseId: enterpriseId,
            selectedDate: selectedDate,
          ),
        ),
      ),
      financialTitlesRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcParams());
    registerFallbackValue(
      SearchFinancialTitleDataParams(
        startDate: DateTime(2026),
        endDate: DateTime(2026, 1, 31),
        enterpriseCodes: const [1],
      ),
    );
  });

  setUp(() {
    repository = MockFinancialTitlesRepository();
    ecParams = EntityFactory.makeEcParams();
    responseEntity = const FinancialTitleDataResponseEntity(
      financialTitlePortions: [
        FinancialTitleDataRowEntity(
          enterpriseCode: enterpriseId,
          receiveLiquidValue: 1000,
          payLiquidValue: 400,
          liquidBalanceValue: 600,
        ),
      ],
      calculatedTotals: FinancialTitleCalculatedTotalsEntity(
        receiveLiquidValue: 1000,
        payLiquidValue: 400,
        liquidBalanceValue: 600,
      ),
    );
    container = makeContainer();
  });

  tearDown(() => container.dispose());

  test('loads daily financial data for the selected month', () async {
    final params = makeParams(HomeFinancialPeriod.daily);
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => responseEntity);

    final result = await container.read(
      homeFinancialControllerProvider(
        enterpriseId,
        HomeFinancialPeriod.daily,
      ).future,
    );

    expect(result, responseEntity);
    verify(
      () => repository.getData(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('loads monthly financial data for the full year', () async {
    final params = makeParams(HomeFinancialPeriod.monthly);
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => responseEntity);

    final result = await container.read(
      homeFinancialControllerProvider(
        enterpriseId,
        HomeFinancialPeriod.monthly,
      ).future,
    );

    expect(result, responseEntity);
    verify(
      () => repository.getData(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('loads yearly financial data for 3-year range', () async {
    final params = makeParams(HomeFinancialPeriod.yearly);
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => responseEntity);

    final result = await container.read(
      homeFinancialControllerProvider(
        enterpriseId,
        HomeFinancialPeriod.yearly,
      ).future,
    );

    expect(result, responseEntity);
    verify(
      () => repository.getData(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('propagates errors when repository throws', () async {
    final params = makeParams(HomeFinancialPeriod.daily);
    final exception = Exception('Network error');
    when(
      () => repository.getData(params: params, ecParams: ecParams),
    ).thenThrow(exception);

    expect(
      () => container.read(
        homeFinancialControllerProvider(
          enterpriseId,
          HomeFinancialPeriod.daily,
        ).future,
      ),
      throwsA(exception),
    );
  });
}
