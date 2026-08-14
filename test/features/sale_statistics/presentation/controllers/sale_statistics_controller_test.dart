// test/features/sale_statistics/presentation/controllers/sale_statistics_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/domain/repository/repository.dart';
import 'package:celta_dash/features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class MockSaleStatisticsRepository extends Mock
    implements ISaleStatisticsRepository {}

void main() {
  late MockSaleStatisticsRepository mockRepository;
  late ProviderContainer container;
  late EcParams tEcParams;
  late GetSaleStatisticsParams tParams;
  late SaleStatisticsEntity tEntity;
  late List<SaleStatisticsEntity> tStatisticsList;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcParams());
    registerFallbackValue(EntityFactory.makeGetSalesParams());
  });

  setUp(() {
    mockRepository = MockSaleStatisticsRepository();
    tEcParams = EntityFactory.makeEcParams();
    tParams = EntityFactory.makeGetSalesParams();
    tEntity = EntityFactory.makeSaleStatisticEntity();
    tStatisticsList = [tEntity];

    container = ProviderContainer(
      overrides: [
        activeEcParamsProvider.overrideWithValue(tEcParams),
        saleStatisticsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SaleStatisticsController.build', () {
    test(
      'should initialize with AsyncValue.data([]) and null lastLoadedParams',
      () {
        final state = container.read(
          saleStatisticsControllerProvider(CategoryGroupingType.product),
        );
        final controller = container.read(
          saleStatisticsControllerProvider(
            CategoryGroupingType.product,
          ).notifier,
        );

        expect(state, const AsyncValue.data(<SaleStatisticsEntity>[]));
        expect(controller.lastLoadedParams, isNull);
      },
    );
  });

  group('SaleStatisticsController.loadStatistics', () {
    test(
      'should set state to AsyncError when activeEcParamsProvider is null',
      () async {
        final containerWithoutEcParams = ProviderContainer(
          overrides: [
            activeEcParamsProvider.overrideWith(() => ActiveEcParams()),
            saleStatisticsRepositoryProvider.overrideWithValue(mockRepository),
          ],
        );
        addTearDown(containerWithoutEcParams.dispose);

        final controller = containerWithoutEcParams.read(
          saleStatisticsControllerProvider(
            CategoryGroupingType.product,
          ).notifier,
        );

        await controller.loadStatistics(params: tParams);

        final state = containerWithoutEcParams.read(
          saleStatisticsControllerProvider(CategoryGroupingType.product),
        );

        expect(state.hasError, isTrue);
        expect(
          state.error,
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Active enterprise credentials (EcParams) not found.'),
          ),
        );
        expect(controller.lastLoadedParams, isNull);
        verifyZeroInteractions(mockRepository);
      },
    );

    test(
      'should transition through loading and set state to AsyncData on success',
      () async {
        when(
          () => mockRepository.getSaleStatistics(
            params: tParams,
            ecParams: tEcParams,
          ),
        ).thenAnswer((_) async => tStatisticsList);

        final provider = saleStatisticsControllerProvider(
          CategoryGroupingType.product,
        );
        final controller = container.read(provider.notifier);

        final states = <AsyncValue<List<SaleStatisticsEntity>>>[];
        container.listen(provider, (_, next) => states.add(next));

        await controller.loadStatistics(params: tParams);

        expect(states, [
          const AsyncValue<List<SaleStatisticsEntity>>.loading(),
          AsyncValue.data(tStatisticsList),
        ]);
        expect(controller.lastLoadedParams, tParams);
        verify(
          () => mockRepository.getSaleStatistics(
            params: tParams,
            ecParams: tEcParams,
          ),
        ).called(1);
      },
    );

    test('should set state to AsyncError when repository throws', () async {
      final tError = Exception('Failed to fetch statistics');
      when(
        () => mockRepository.getSaleStatistics(
          params: tParams,
          ecParams: tEcParams,
        ),
      ).thenThrow(tError);

      final provider = saleStatisticsControllerProvider(
        CategoryGroupingType.product,
      );
      final controller = container.read(provider.notifier);

      await controller.loadStatistics(params: tParams);

      final state = container.read(provider);
      expect(state.hasError, isTrue);
      expect(state.error, tError);
      expect(controller.lastLoadedParams, isNull);
      verify(
        () => mockRepository.getSaleStatistics(
          params: tParams,
          ecParams: tEcParams,
        ),
      ).called(1);
    });

    test(
      'should not call repository when params are unchanged, state hasValue, and forceRefresh is false',
      () async {
        when(
          () => mockRepository.getSaleStatistics(
            params: tParams,
            ecParams: tEcParams,
          ),
        ).thenAnswer((_) async => tStatisticsList);

        final provider = saleStatisticsControllerProvider(
          CategoryGroupingType.product,
        );
        final controller = container.read(provider.notifier);

        await controller.loadStatistics(params: tParams);
        expect(container.read(provider).value, tStatisticsList);

        // Second call with same params without forceRefresh
        await controller.loadStatistics(params: tParams);

        verify(
          () => mockRepository.getSaleStatistics(
            params: tParams,
            ecParams: tEcParams,
          ),
        ).called(1);
      },
    );

    test(
      'should call repository again when forceRefresh is true even if params are unchanged',
      () async {
        when(
          () => mockRepository.getSaleStatistics(
            params: tParams,
            ecParams: tEcParams,
          ),
        ).thenAnswer((_) async => tStatisticsList);

        final provider = saleStatisticsControllerProvider(
          CategoryGroupingType.product,
        );
        final controller = container.read(provider.notifier);

        await controller.loadStatistics(params: tParams);
        await controller.loadStatistics(params: tParams, forceRefresh: true);

        verify(
          () => mockRepository.getSaleStatistics(
            params: tParams,
            ecParams: tEcParams,
          ),
        ).called(2);
      },
    );
  });
}
