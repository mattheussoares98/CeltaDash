import 'dart:async';

import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/buy_movement/presentation/models/models.dart';
import 'package:celta_dash/features/buy_movement/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockBuyMovementRepository repository;
  late ProviderContainer container;
  late EcParams ecParams;
  late SearchBuyMovementDataParamsEntity params;
  late BuyMovementDataResponseEntity response;

  BuyMovementController controller(BuyMovementQuerySlot slot) =>
      container.read(buyMovementControllerProvider(slot).notifier);

  setUp(() {
    repository = MockBuyMovementRepository();
    ecParams = EntityFactory.makeEcParams();
    params = BuyMovementEntityFactory.makeSearchParams();
    response = BuyMovementEntityFactory.makeResponseEntity(
      searchParameters: params,
    );
    container = ProviderContainer(
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => MutableActiveEcParams(ecParams),
        ),
        buyMovementRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('BuyMovementController.build', () {
    test('starts empty and isolates each query slot', () async {
      when(
        () => repository.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => response);

      await controller(BuyMovementQuerySlot.hourly).loadData(params: params);

      expect(
        container.read(
          buyMovementControllerProvider(BuyMovementQuerySlot.hourly),
        ),
        AsyncValue.data(response),
      );
      expect(
        container.read(
          buyMovementControllerProvider(BuyMovementQuerySlot.products),
        ),
        const AsyncValue.data(BuyMovementDataResponseEntity()),
      );
    });
  });

  group('BuyMovementController.loadData', () {
    test(
      'returns a clear error when Commerce credentials are missing',
      () async {
        final noCredentialsContainer = ProviderContainer(
          overrides: [
            activeEcParamsStateControllerProvider.overrideWith(
              () => MutableActiveEcParams(null),
            ),
            buyMovementRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(noCredentialsContainer.dispose);
        final notifier = noCredentialsContainer.read(
          buyMovementControllerProvider(BuyMovementQuerySlot.daily).notifier,
        );

        final result = await notifier.loadData(params: params);

        expect(result.hasError, isTrue);
        expect(
          result.error.toString(),
          contains('Credenciais da empresa ativa não encontradas'),
        );
        verifyZeroInteractions(repository);
      },
    );

    test('loads data successfully', () async {
      when(
        () => repository.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => response);

      final result = await controller(
        BuyMovementQuerySlot.daily,
      ).loadData(params: params);

      expect(result, AsyncValue.data(response));
      verify(
        () => repository.getData(params: params, ecParams: ecParams),
      ).called(1);
    });

    test('reuses data when equal parameters are already loaded', () async {
      when(
        () => repository.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => response);
      final notifier = controller(BuyMovementQuerySlot.monthly);

      await notifier.loadData(params: params);
      final result = await notifier.loadData(params: params);

      expect(result, AsyncValue.data(response));
      verify(
        () => repository.getData(params: params, ecParams: ecParams),
      ).called(1);
    });

    test(
      'forces a refresh and preserves previous data while loading',
      () async {
        final refreshCompleter = Completer<BuyMovementDataResponseEntity>();
        var calls = 0;
        when(
          () => repository.getData(params: params, ecParams: ecParams),
        ).thenAnswer((_) {
          calls++;
          return calls == 1 ? Future.value(response) : refreshCompleter.future;
        });
        final provider = buyMovementControllerProvider(
          BuyMovementQuerySlot.yearly,
        );
        final notifier = container.read(provider.notifier);

        await notifier.loadData(params: params);
        final refresh = notifier.loadData(params: params, forceRefresh: true);
        await Future<void>.delayed(Duration.zero);

        final loadingState = container.read(provider);
        expect(loadingState.isLoading, isTrue);
        expect(loadingState.value, response);

        refreshCompleter.complete(response);
        await refresh;
        verify(
          () => repository.getData(params: params, ecParams: ecParams),
        ).called(2);
      },
    );

    test('loads again when parameters change', () async {
      final changedParams = BuyMovementEntityFactory.makeSearchParams(
        enterpriseCodes: const [2],
      );
      when(
        () => repository.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => response);
      when(
        () => repository.getData(params: changedParams, ecParams: ecParams),
      ).thenAnswer((_) async => response);
      final notifier = controller(BuyMovementQuerySlot.daily);

      await notifier.loadData(params: params);
      await notifier.loadData(params: changedParams);

      verify(
        () => repository.getData(params: params, ecParams: ecParams),
      ).called(1);
      verify(
        () => repository.getData(params: changedParams, ecParams: ecParams),
      ).called(1);
    });

    test('exposes repository errors', () async {
      final exception = Exception('request failed');
      when(
        () => repository.getData(params: params, ecParams: ecParams),
      ).thenThrow(exception);

      final result = await controller(
        BuyMovementQuerySlot.products,
      ).loadData(params: params);

      expect(result.hasError, isTrue);
      expect(result.error, same(exception));
    });

    test('invalidates cached data when Commerce parameters change', () async {
      final newEcParams = ecParams.copyWith(accessKey: 'new-access-key');
      when(
        () => repository.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => response);
      when(
        () => repository.getData(params: params, ecParams: newEcParams),
      ).thenAnswer((_) async => response);
      final provider = buyMovementControllerProvider(
        BuyMovementQuerySlot.hourly,
      );
      final notifier = container.read(provider.notifier);

      await notifier.loadData(params: params);
      final activeParams =
          container.read(activeEcParamsStateControllerProvider.notifier)
              as MutableActiveEcParams;
      activeParams.setValue(newEcParams);
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(provider),
        const AsyncValue.data(BuyMovementDataResponseEntity()),
      );

      await container.read(provider.notifier).loadData(params: params);
      verify(
        () => repository.getData(params: params, ecParams: ecParams),
      ).called(1);
      verify(
        () => repository.getData(params: params, ecParams: newEcParams),
      ).called(1);
    });
  });
}
