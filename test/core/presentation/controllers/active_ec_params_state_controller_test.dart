// test/core/presentation/controllers/active_ec_params_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';

class MockLocalStorage extends Mock implements IAppStorage {}

void main() {
  late MockLocalStorage mockLocalStorage;
  late ProviderContainer container;
  late EcParams tEcParams;
  late FirebaseEnterpriseEntity tEnterprise;

  setUpAll(() {
    registerFallbackValue(DatabaseKeys.enterprise.name);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    tEnterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    tEcParams = EcParams.fromFirebaseEnterprise(tEnterprise)!;

    when(
      () => mockLocalStorage.get(DatabaseKeys.enterprise.name),
    ).thenAnswer((_) async => null);
    when(
      () => mockLocalStorage.put(DatabaseKeys.enterprise.name, any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalStorage.delete(DatabaseKeys.enterprise.name),
    ).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [appStorageProvider.overrideWithValue(mockLocalStorage)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ActiveEcParams.build', () {
    test(
      'should initialize with null when local storage has no saved enterprise',
      () async {
        final state = await container.read(
          activeEcParamsStateControllerProvider.future,
        );
        expect(state, isNull);
      },
    );

    test(
      'should auto-load saved enterprise from localStorage on build',
      () async {
        final enterpriseJson = FirebaseEnterpriseModel.fromEntity(
          tEnterprise,
        ).toJson();

        when(
          () => mockLocalStorage.get(DatabaseKeys.enterprise.name),
        ).thenAnswer((_) async => enterpriseJson);

        final newContainer = ProviderContainer(
          overrides: [appStorageProvider.overrideWithValue(mockLocalStorage)],
        );
        addTearDown(newContainer.dispose);

        final state = await newContainer.read(
          activeEcParamsStateControllerProvider.future,
        );
        expect(state, tEcParams);
        verify(() => mockLocalStorage.get(DatabaseKeys.enterprise.name)).called(1);
      },
    );
  });

  group('ActiveEcParams.updateParams', () {
    test(
      'should update in-memory state and persist enterprise to localStorage when enterprise is provided',
      () async {
        final controller = container.read(
          activeEcParamsStateControllerProvider.notifier,
        );

        final expectedJson = FirebaseEnterpriseModel.fromEntity(
          tEnterprise,
        ).toJson();

        await controller.updateParams(
          params: tEcParams,
          enterprise: tEnterprise,
        );

        final state = await container.read(
          activeEcParamsStateControllerProvider.future,
        );
        expect(state, tEcParams);

        verify(
          () => mockLocalStorage.put(DatabaseKeys.enterprise.name, expectedJson),
        ).called(1);
      },
    );

    test(
      'should update in-memory state without persisting when enterprise is null',
      () async {
        final controller = container.read(
          activeEcParamsStateControllerProvider.notifier,
        );

        await controller.updateParams(params: tEcParams);

        final state = await container.read(
          activeEcParamsStateControllerProvider.future,
        );
        expect(state, tEcParams);

        verifyNever(() => mockLocalStorage.put(DatabaseKeys.enterprise.name, any()));
      },
    );
  });

  group('ActiveEcParams.clear', () {
    test(
      'should reset state to null and delete enterprise from localStorage',
      () async {
        final controller = container.read(
          activeEcParamsStateControllerProvider.notifier,
        );

        await controller.updateParams(
          params: tEcParams,
          enterprise: tEnterprise,
        );
        expect(
          await container.read(activeEcParamsStateControllerProvider.future),
          tEcParams,
        );

        await controller.clear();

        expect(
          await container.read(activeEcParamsStateControllerProvider.future),
          isNull,
        );
        verify(
          () => mockLocalStorage.delete(DatabaseKeys.enterprise.name),
        ).called(1);
      },
    );
  });
}
