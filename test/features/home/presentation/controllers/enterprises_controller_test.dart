import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
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
  late EcParams ecParams;

  ProviderContainer makeContainer([EcParams? activeEcParams]) =>
      ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          activeEcParamsStateControllerProvider.overrideWith(
            () => FakeActiveEcParams(activeEcParams),
          ),
          homeRepositoryProvider.overrideWithValue(repository),
        ],
      );

  setUp(() {
    repository = MockHomeRepository();
    ecParams = EntityFactory.makeEcParams();
  });

  test('build loads enterprises and reconciles enabled metadata', () async {
    final enabledEnterprise = HomeEntityFactory.makeHomeEnterpriseEntity(
      id: 1,
      enabled: false,
    );
    final disabledEnterprise = HomeEntityFactory.makeHomeEnterpriseEntity(
      id: 2,
      enabled: true,
    );
    final activeEnterprise = EntityFactory.makeFirebaseEnterpriseEntity()
        .copyWith(
          firebaseSubEnterprises: [
            EntityFactory.makeFirebaseSubEnterpriseEntity(id: 1, enabled: true),
            EntityFactory.makeFirebaseSubEnterpriseEntity(
              id: 2,
              enabled: false,
            ),
          ],
        );
    when(
      () => repository.loadActiveEnterprise(),
    ).thenAnswer((_) async => activeEnterprise);
    when(
      () => repository.getEnterprises(ecParams),
    ).thenAnswer((_) async => [enabledEnterprise, disabledEnterprise]);
    final container = makeContainer(ecParams);
    addTearDown(container.dispose);

    final enterprises = await container.read(
      enterprisesControllerProvider.future,
    );

    expect(enterprises.map((enterprise) => enterprise.id), [1, 2]);
    expect(enterprises.map((enterprise) => enterprise.enabled), [true, false]);
    verify(() => repository.loadActiveEnterprise()).called(1);
    verify(() => repository.getEnterprises(ecParams)).called(1);
  });

  test(
    'build marks enterprises without Firebase metadata as disabled',
    () async {
      final enterprise = HomeEntityFactory.makeHomeEnterpriseEntity(
        enabled: true,
      );
      when(
        () => repository.loadActiveEnterprise(),
      ).thenAnswer((_) async => null);
      when(
        () => repository.getEnterprises(ecParams),
      ).thenAnswer((_) async => [enterprise]);
      final container = makeContainer(ecParams);
      addTearDown(container.dispose);

      final enterprises = await container.read(
        enterprisesControllerProvider.future,
      );

      expect(enterprises.single.enabled, isFalse);
    },
  );

  test('build returns an empty list without active EC parameters', () async {
    final container = makeContainer();
    addTearDown(container.dispose);

    final enterprises = await container.read(
      enterprisesControllerProvider.future,
    );

    expect(enterprises, isEmpty);
    verifyNever(() => repository.loadActiveEnterprise());
    verifyNever(() => repository.getEnterprises(ecParams));
  });

  test('build exposes repository failures', () async {
    final error = Exception('enterprise loading failed');
    when(() => repository.loadActiveEnterprise()).thenAnswer((_) async => null);
    when(() => repository.getEnterprises(ecParams)).thenThrow(error);
    final container = makeContainer(ecParams);
    addTearDown(container.dispose);

    await expectLater(
      container.read(enterprisesControllerProvider.future),
      throwsA(same(error)),
    );
  });
}
