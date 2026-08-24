import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/presentation/presentation.dart';
import 'package:celta_dash/features/web_enterprises/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockWebEnterprisesRepository repository;

  setUp(() => repository = MockWebEnterprisesRepository());

  test('build loads remote enterprises', () async {
    final enterprises = [EntityFactory.makeFirebaseEnterpriseEntity()];
    when(repository.getEnterprises).thenAnswer((_) async => enterprises);
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(remoteEnterprisesControllerProvider.future),
      enterprises,
    );
  });

  test('refresh replaces the current enterprise result', () async {
    final first = [EntityFactory.makeFirebaseEnterpriseEntity()];
    final refreshed = [EntityFactory.makeFirebaseEnterpriseEntity()];
    var requestCount = 0;
    when(
      repository.getEnterprises,
    ).thenAnswer((_) async => requestCount++ == 0 ? first : refreshed);
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(remoteEnterprisesControllerProvider.future);

    await container
        .read(remoteEnterprisesControllerProvider.notifier)
        .refresh();

    expect(
      container.read(remoteEnterprisesControllerProvider).value,
      refreshed,
    );
  });

  test('updateEnterprise persists and replaces the matching item', () async {
    final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();
    final updated = enterprise.copyWith(baseUrl: faker.internet.httpUrl());
    when(repository.getEnterprises).thenAnswer((_) async => [enterprise]);
    when(() => repository.updateEnterprise(updated)).thenAnswer((_) async {});
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(remoteEnterprisesControllerProvider.future);

    await container
        .read(remoteEnterprisesControllerProvider.notifier)
        .updateEnterprise(updated);

    expect(container.read(remoteEnterprisesControllerProvider).value, [
      updated,
    ]);
    verify(() => repository.updateEnterprise(updated)).called(1);
  });

  test('createEnterprise appends the repository result', () async {
    final existing = EntityFactory.makeFirebaseEnterpriseEntity();
    final created = EntityFactory.makeFirebaseEnterpriseEntity();
    final params = CreateWebEnterpriseParams(
      baseUrl: created.baseUrl!,
      enterpriseName: created.enterpriseName!,
      user: faker.person.name(),
      password: faker.internet.password(),
    );
    when(repository.getEnterprises).thenAnswer((_) async => [existing]);
    when(
      () => repository.createEnterprise(params),
    ).thenAnswer((_) async => created);
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(remoteEnterprisesControllerProvider.future);

    await container
        .read(remoteEnterprisesControllerProvider.notifier)
        .createEnterprise(params);

    expect(container.read(remoteEnterprisesControllerProvider).value, [
      existing,
      created,
    ]);
  });

  test('createEnterprise rejects a duplicated normalized name', () async {
    final existing = EntityFactory.makeFirebaseEnterpriseEntity();
    final params = CreateWebEnterpriseParams(
      baseUrl: faker.internet.httpUrl(),
      enterpriseName: '  ${existing.enterpriseName!}  ',
      user: faker.person.name(),
      password: faker.internet.password(),
    );
    when(repository.getEnterprises).thenAnswer((_) async => [existing]);
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(remoteEnterprisesControllerProvider.future);

    expect(
      () => container
          .read(remoteEnterprisesControllerProvider.notifier)
          .createEnterprise(params),
      throwsA(isA<AppException>()),
    );
    verifyNever(() => repository.createEnterprise(params));
  });
}
