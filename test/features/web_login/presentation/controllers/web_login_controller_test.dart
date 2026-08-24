import 'package:celta_dash/features/web_login/presentation/presentation.dart';
import 'package:celta_dash/features/web_login/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockWebLoginRepository repository;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [webLoginRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => repository = MockWebLoginRepository());

  test('build exposes the current authentication state', () async {
    when(repository.isLoggedIn).thenAnswer((_) async => true);
    final container = makeContainer();

    final state = await container.read(webLoginControllerProvider.future);

    expect(state.isAuthenticated, isTrue);
    verify(repository.isLoggedIn).called(1);
  });

  test('login authenticates and updates the state', () async {
    final email = faker.internet.email();
    final password = faker.internet.password();
    when(repository.isLoggedIn).thenAnswer((_) async => false);
    when(
      () => repository.login(email: email, password: password),
    ).thenAnswer((_) async {});
    final container = makeContainer();
    await container.read(webLoginControllerProvider.future);

    await container
        .read(webLoginControllerProvider.notifier)
        .login(email: email, password: password);

    final state = container.read(webLoginControllerProvider).value!;
    expect(state.isAuthenticated, isTrue);
    expect(state.isSubmitting, isFalse);
    expect(state.actionError, isNull);
  });

  test('login retains the form and exposes authentication failures', () async {
    final email = faker.internet.email();
    final password = faker.internet.password();
    final error = Exception(faker.lorem.sentence());
    when(repository.isLoggedIn).thenAnswer((_) async => false);
    when(
      () => repository.login(email: email, password: password),
    ).thenThrow(error);
    final container = makeContainer();
    await container.read(webLoginControllerProvider.future);

    await container
        .read(webLoginControllerProvider.notifier)
        .login(email: email, password: password);

    final state = container.read(webLoginControllerProvider).value!;
    expect(state.isAuthenticated, isFalse);
    expect(state.isSubmitting, isFalse);
    expect(state.actionError, same(error));
  });
}
