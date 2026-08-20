import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockHomeRepository repository;
  late ProviderContainer container;
  late EcParams ecParams;
  late HomeEnterpriseEntity enabledEnterprise;
  late HomeEnterpriseEntity disabledEnterprise;
  late FirebaseEnterpriseEntity activeEnterprise;

  setUp(() {
    repository = MockHomeRepository();
    ecParams = EntityFactory.makeEcParams();
    enabledEnterprise = HomeEntityFactory.makeHomeEnterpriseEntity(
      id: 1,
      enabled: false,
    );
    disabledEnterprise = HomeEntityFactory.makeHomeEnterpriseEntity(
      id: 2,
      enabled: false,
    );
    activeEnterprise = EntityFactory.makeFirebaseEnterpriseEntity().copyWith(
      firebaseSubEnterprises: [
        EntityFactory.makeFirebaseSubEnterpriseEntity(id: 1, enabled: true),
        EntityFactory.makeFirebaseSubEnterpriseEntity(id: 2, enabled: false),
      ],
    );
    when(() => repository.loadAppMode()).thenAnswer((_) async => AppMode.sales);
    when(
      () => repository.loadActiveEnterprise(),
    ).thenAnswer((_) async => activeEnterprise);
    when(
      () => repository.getEnterprises(ecParams),
    ).thenAnswer((_) async => [enabledEnterprise, disabledEnterprise]);

    container = ProviderContainer(
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => FakeActiveEcParams(ecParams),
        ),
        homeRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<HomeState> loadState() =>
      container.read(homeControllerProvider.future);

  test('build loads mode and selects the first enabled enterprise', () async {
    final state = await loadState();

    expect(state.appMode, AppMode.sales);
    expect(state.selectedEnterpriseId, 1);
  });

  test('build select first enabled enterprise', () async {
    when(() => repository.loadActiveEnterprise()).thenAnswer((_) async => null);

    final state = await loadState();

    expect(state.selectedEnterpriseId, enabledEnterprise.id);
  });

  test('build supports an empty enterprise response', () async {
    when(() => repository.getEnterprises(ecParams)).thenAnswer((_) async => []);

    final state = await loadState();

    expect(state.selectedEnterpriseId, isNull);
  });

  test('selectDate updates only the selected date', () async {
    final oldState = await loadState();
    final newDate = oldState.selectedDate.add(const Duration(days: 1));

    container.read(homeControllerProvider.notifier).selectDate(newDate);

    expect(container.read(homeControllerProvider).value?.selectedDate, newDate);
    expect(
      container.read(homeControllerProvider).value?.selectedEnterpriseId,
      oldState.selectedEnterpriseId,
    );
  });

  test(
    'selectEnterprise rejects a disabled enterprise with feedback',
    () async {
      await loadState();

      container.read(homeControllerProvider.notifier).selectEnterprise(2);

      final state = container.read(homeControllerProvider).value!;
      expect(state.selectedEnterpriseId, 1);
    },
  );

  test('toggleAppMode persists before publishing the new mode', () async {
    when(
      () => repository.saveAppMode(AppMode.financialTitles),
    ).thenAnswer((_) async {});
    await loadState();

    await container.read(homeControllerProvider.notifier).toggleAppMode();

    verify(() => repository.saveAppMode(AppMode.financialTitles)).called(1);
    expect(
      container.read(homeControllerProvider).value?.appMode,
      AppMode.financialTitles,
    );
  });

  test('toggleAppMode keeps the old mode when persistence fails', () async {
    final error = Exception('storage failed');
    when(
      () => repository.saveAppMode(AppMode.financialTitles),
    ).thenThrow(error);
    await loadState();

    await expectLater(
      container.read(homeControllerProvider.notifier).toggleAppMode(),
      throwsA(error),
    );

    expect(
      container.read(homeControllerProvider).value?.appMode,
      AppMode.sales,
    );
  });

  test('logout clears the persisted Home session', () async {
    when(() => repository.logout()).thenAnswer((_) async {});
    await loadState();

    await container.read(homeControllerProvider.notifier).logout();

    verify(() => repository.logout()).called(1);
  });

  test(
    'build skips disabled enterprises when initializing selection',
    () async {
      activeEnterprise = activeEnterprise.copyWith(
        firebaseSubEnterprises: [
          EntityFactory.makeFirebaseSubEnterpriseEntity(id: 1, enabled: false),
          EntityFactory.makeFirebaseSubEnterpriseEntity(id: 2, enabled: true),
        ],
      );
      when(
        () => repository.loadActiveEnterprise(),
      ).thenAnswer((_) async => activeEnterprise);

      final state = await loadState();

      expect(state.selectedEnterpriseId, 2);
    },
  );
}
