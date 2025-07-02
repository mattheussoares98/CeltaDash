import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late EnterprisesManagerPresenterSpy enterprisesManagerPresenter;

  late NavigateToSpy navigateTo;

  late String enterpriseName;
  late String user;
  late String password;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
  }

  void initPresenters() {
    sut = GetxLoginPresenter(
      navigateTo: navigateTo,
    );
    enterprisesManagerPresenter = EnterprisesManagerPresenterSpy();
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    enterpriseName = faker.company.name();
    user = faker.person.name();
    password = faker.internet.password();
  }

  void initMockSuccess() {}

  setUp(() {
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }

    initEntities();
    initUsecases();
    initPresenters();
    initMockSuccess();
  });

  group("Login", () {
    test(
        "Should call EnterprisesManagerPresenter.addNewEnterprise with correct values",
        () async {
      await sut.login(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        enterpriseName: enterpriseName,
        user: user,
        password: password,
      );

      verify(() => enterprisesManagerPresenter.addNewEnterprise(
            enterpriseName: enterpriseName,
            userName: user,
            userPassword: password,
          )).called(1);
    });
    test(
        "Should go to home page when EnterprisesManagerPresenter.addNewEnterprise returns true",
        () async {
      await sut.login(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        enterpriseName: enterpriseName,
        user: user,
        password: password,
      );

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
          .called(1);
    });
    test(
        "Should NOT go to home page when EnterprisesManagerPresenter.addNewEnterprise returns false",
        () async {
      enterprisesManagerPresenter.mockAddNewEnterprise(false);

      await sut.login(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        enterpriseName: enterpriseName,
        user: user,
        password: password,
      );

      verifyNever(
        () => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true),
      );
    });
  });

  group("Go to web login page", () {
    test("Should call navigateTo with correct values", () {
      sut.goToWebLoginPage();

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.webLogin));
    });
  });
}
