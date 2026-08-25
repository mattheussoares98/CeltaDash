// test/features/financial_titles/presentation/controllers/financial_titles_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/domain/repository/repository.dart';
import 'package:celta_dash/features/financial_titles/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/financial_titles/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';

class MockFinancialTitlesRepository extends Mock
    implements IFinancialTitlesRepository {}

void main() {
  late MockFinancialTitlesRepository mockRepository;
  late ProviderContainer container;
  late EcParams tEcParams;
  late SearchFinancialTitleDataParams tParams;
  late FinancialTitleDataResponseEntity tEntity;

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
    mockRepository = MockFinancialTitlesRepository();
    tEcParams = EntityFactory.makeEcParams();
    tParams = SearchFinancialTitleDataParams(
      startDate: DateTime(2026),
      endDate: DateTime(2026, 1, 31),
      enterpriseCodes: const [1],
    );
    tEntity = const FinancialTitleDataResponseEntity(
      financialTitlePortions: [
        FinancialTitleDataRowEntity(
          financialTitleCode: 100,
          receiveLiquidValue: 500,
          payLiquidValue: 200,
          liquidBalanceValue: 300,
        ),
      ],
      calculatedTotals: FinancialTitleCalculatedTotalsEntity(
        receiveLiquidValue: 500,
        payLiquidValue: 200,
        liquidBalanceValue: 300,
      ),
    );

    container = ProviderContainer(
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => FakeActiveEcParams(tEcParams),
        ),
        financialTitlesRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FinancialTitlesController.build', () {
    test(
      'should initialize with default empty response and null lastLoadedParams',
      () {
        final state = container.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ),
        );
        final controller = container.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ).notifier,
        );

        expect(
          state,
          const AsyncValue.data(FinancialTitleDataResponseEntity()),
        );
        expect(controller.lastLoadedParams, isNull);
      },
    );
  });

  group('FinancialTitlesController.loadData', () {
    test(
      'should set state to AsyncError when activeEcParams is null',
      () async {
        final containerWithoutEcParams = ProviderContainer(
          overrides: [
            activeEcParamsStateControllerProvider.overrideWith(
              () => FakeActiveEcParams(),
            ),
            financialTitlesRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );
        addTearDown(containerWithoutEcParams.dispose);

        final controller = containerWithoutEcParams.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ).notifier,
        );

        await controller.loadData(params: tParams);

        final state = containerWithoutEcParams.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ),
        );

        expect(state.hasError, isTrue);
        expect(
          state.error.toString(),
          contains('Credenciais da empresa ativa não encontradas'),
        );
      },
    );

    test('should load data successfully and update lastLoadedParams', () async {
      when(
        () => mockRepository.getData(
          params: any(named: 'params'),
          ecParams: any(named: 'ecParams'),
        ),
      ).thenAnswer((_) async => tEntity);

      final controller = container.read(
        financialTitlesControllerProvider(
          periodGrouping: FinancialTitlePeriodGrouping.day,
        ).notifier,
      );

      final result = await controller.loadData(params: tParams);

      expect(result, AsyncValue.data(tEntity));
      expect(controller.lastLoadedParams, tParams);

      verify(
        () => mockRepository.getData(params: tParams, ecParams: tEcParams),
      ).called(1);
    });

    test(
      'should return cached state without calling repository when params are the same and forceRefresh is false',
      () async {
        when(
          () => mockRepository.getData(
            params: any(named: 'params'),
            ecParams: any(named: 'ecParams'),
          ),
        ).thenAnswer((_) async => tEntity);

        final controller = container.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ).notifier,
        );

        await controller.loadData(params: tParams);
        final secondCall = await controller.loadData(params: tParams);

        expect(secondCall, AsyncValue.data(tEntity));
        verify(
          () => mockRepository.getData(params: tParams, ecParams: tEcParams),
        ).called(1);
      },
    );

    test(
      'should re-fetch from repository when forceRefresh is true even if params are unchanged',
      () async {
        when(
          () => mockRepository.getData(
            params: any(named: 'params'),
            ecParams: any(named: 'ecParams'),
          ),
        ).thenAnswer((_) async => tEntity);

        final controller = container.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ).notifier,
        );

        await controller.loadData(params: tParams);
        await controller.loadData(params: tParams, forceRefresh: true);

        verify(
          () => mockRepository.getData(params: tParams, ecParams: tEcParams),
        ).called(2);
      },
    );

    test(
      'should set state to AsyncError when repository throws exception',
      () async {
        final tException = Exception('Failed to load data');
        when(
          () => mockRepository.getData(
            params: any(named: 'params'),
            ecParams: any(named: 'ecParams'),
          ),
        ).thenThrow(tException);

        final controller = container.read(
          financialTitlesControllerProvider(
            periodGrouping: FinancialTitlePeriodGrouping.day,
          ).notifier,
        );

        final result = await controller.loadData(params: tParams);

        expect(result.hasError, isTrue);
        expect(result.error, tException);
      },
    );
  });
}
