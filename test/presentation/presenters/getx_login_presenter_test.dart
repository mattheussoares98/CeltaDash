import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;

  late NavigateToSpy navigateTo;
  late RemoteLoginSpy remoteLogin;

  late String email;
  late String password;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    remoteLogin = RemoteLoginSpy();
  }

  void initPresenters() {
    sut = GetxLoginPresenter(navigateTo: navigateTo, remoteLogin: remoteLogin);
  }

  void initEntities() {
    email = faker.internet.email();
    password = faker.internet.password();
  }

  void initMockSuccess() {}

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });

  group("Login", () {
    test("Should navigate to home page", () async {
      await sut.login(user: email, password: password);

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true),
      ).called(1);
    });
  });
}
