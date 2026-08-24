import 'package:celta_dash/features/web_enterprises/presentation/presentation.dart';
import 'package:celta_dash/features/web_enterprises/providers.dart';
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
    when(repository.getEnterprises).thenAnswer(
      (_) async => requestCount++ == 0 ? first : refreshed,
    );
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
}
