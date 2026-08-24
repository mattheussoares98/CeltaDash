import 'package:celta_dash/features/web_login/data/data.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockFirebaseAuthStorage firebaseAuthStorage;
  late WebLoginDatasource datasource;

  setUp(() {
    firebaseAuthStorage = MockFirebaseAuthStorage();
    datasource = WebLoginDatasource(firebaseAuthStorage);
  });

  test('isLoggedIn forwards the current Firebase session state', () async {
    when(firebaseAuthStorage.isLoggedIn).thenAnswer((_) async => true);

    expect(await datasource.isLoggedIn(), isTrue);
    verify(firebaseAuthStorage.isLoggedIn).called(1);
  });

  test('login forwards the credentials to Firebase', () async {
    final email = faker.internet.email();
    final password = faker.internet.password();
    when(
      () => firebaseAuthStorage.login(email: email, password: password),
    ).thenAnswer((_) async {});

    await datasource.login(email: email, password: password);

    verify(
      () => firebaseAuthStorage.login(email: email, password: password),
    ).called(1);
  });
}
