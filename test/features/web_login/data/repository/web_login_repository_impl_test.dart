import 'package:celta_dash/features/web_login/data/data.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockWebLoginDatasource datasource;
  late WebLoginRepositoryImpl repository;

  setUp(() {
    datasource = MockWebLoginDatasource();
    repository = WebLoginRepositoryImpl(datasource);
  });

  test('isLoggedIn forwards the datasource result', () async {
    when(datasource.isLoggedIn).thenAnswer((_) async => false);

    expect(await repository.isLoggedIn(), isFalse);
    verify(datasource.isLoggedIn).called(1);
  });

  test('login forwards the credentials to the datasource', () async {
    final email = faker.internet.email();
    final password = faker.internet.password();
    when(
      () => datasource.login(email: email, password: password),
    ).thenAnswer((_) async {});

    await repository.login(email: email, password: password);

    verify(() => datasource.login(email: email, password: password)).called(1);
  });
}
