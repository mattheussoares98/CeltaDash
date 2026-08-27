import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/enterprises_manager/presentation/presentation.dart';
import 'package:celta_dash/features/enterprises_manager/providers.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockEnterprisesManagerRepository repository;
  late MockAppStorage localStorage;
  late ProviderContainer container;
  late FirebaseEnterpriseEntity selectedEnterprise;
  late FirebaseEnterpriseEntity otherEnterprise;

  setUp(() {
    repository = MockEnterprisesManagerRepository();
    localStorage = MockAppStorage();
    selectedEnterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    otherEnterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    when(
      () => repository.loadEnterprises(),
    ).thenAnswer((_) async => [otherEnterprise, selectedEnterprise]);
    when(
      () => repository.loadSelectedEnterprise(),
    ).thenAnswer((_) async => selectedEnterprise);
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        enterprisesManagerRepositoryProvider.overrideWithValue(repository),
        appStorageProvider.overrideWithValue(localStorage),
      ],
    );
    addTearDown(container.dispose);
  });

  test('build loads and places the selected enterprise first', () async {
    final state = await container.read(
      enterprisesManagerControllerProvider.future,
    );

    expect(state.enterprises, [selectedEnterprise, otherEnterprise]);
    expect(state.isSelected(selectedEnterprise), true);
  });

  test(
    'addEnterprise delegates and reloads while preserving content',
    () async {
      final params = EntityFactory.makeAddEnterpriseParams();
      when(
        () => repository.addEnterprise(params),
      ).thenAnswer((_) async => otherEnterprise);
      await container.read(enterprisesManagerControllerProvider.future);

      final success = await container
          .read(enterprisesManagerControllerProvider.notifier)
          .addEnterprise(params);

      expect(success, true);
      expect(
        container.read(enterprisesManagerControllerProvider).value?.enterprises,
        [selectedEnterprise, otherEnterprise],
      );
      verify(() => repository.addEnterprise(params)).called(1);
    },
  );

  test(
    'selectEnterprise persists the existing legacy enterprise key',
    () async {
      final json = FirebaseEnterpriseModel.fromEntity(otherEnterprise).toJson();
      when(
        () => localStorage.put(DatabaseKeys.enterprise.name, json),
      ).thenAnswer((_) async {});
      await container.read(enterprisesManagerControllerProvider.future);

      final success = await container
          .read(enterprisesManagerControllerProvider.notifier)
          .selectEnterprise(otherEnterprise);

      expect(success, true);
      verify(() => localStorage.put(DatabaseKeys.enterprise.name, json)).called(1);
    },
  );

  test('removeEnterprise delegates and reloads', () async {
    when(
      () => repository.removeEnterprise(otherEnterprise),
    ).thenAnswer((_) async {});
    await container.read(enterprisesManagerControllerProvider.future);

    final success = await container
        .read(enterprisesManagerControllerProvider.notifier)
        .removeEnterprise(otherEnterprise);

    expect(success, true);
    verify(() => repository.removeEnterprise(otherEnterprise)).called(1);
  });

  test(
    'mutation errors retain loaded enterprises and surface the error',
    () async {
      final error = Exception('remove failed');
      when(() => repository.removeEnterprise(otherEnterprise)).thenThrow(error);
      await container.read(enterprisesManagerControllerProvider.future);

      final success = await container
          .read(enterprisesManagerControllerProvider.notifier)
          .removeEnterprise(otherEnterprise);
      final state = container.read(enterprisesManagerControllerProvider).value!;

      expect(success, false);
      expect(state.enterprises, [selectedEnterprise, otherEnterprise]);
      expect(state.actionError, error);
      expect(state.isProcessing, false);
    },
  );
}
