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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late GetxWebLoginPresenter sut;

  late NavigateToSpy navigateTo;
  late FirebaseLoginManagementSpy firebaseLoginManagement;

  late String email;
  late String password;

  initUseCases() {
    navigateTo = NavigateToSpy();
    firebaseLoginManagement = FirebaseLoginManagementSpy();
  }

  initPresenters() {
    sut = GetxWebLoginPresenter(
      navigateTo: navigateTo,
      firebaseLoginManagement: firebaseLoginManagement,
    );
  }

  initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    email = faker.internet.httpUrl();
    password = faker.guid.guid();
  }

  mockSuccess() {}

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {});

  group("Login", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.doLogin(email: email, password: password);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      firebaseLoginManagement.mockLoginError();
      await sut.doLogin(email: email, password: password);
    });
    test("Should call login with correct values", () async {
      await sut.doLogin(email: email, password: password);

      verify(() => firebaseLoginManagement.login(
            email: email,
            password: password,
          )).called(1);
    });
    test("Should call navigateTo web customers in success", () async {
      await sut.doLogin(email: email, password: password);

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.webEnterprises),
      ).called(1);
    });
  });

  group("Logout", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.doLogout();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      firebaseLoginManagement.mockLogoutError();
      await sut.doLogout();
    });
    test("Should call loginManagement.logout", () async {
      await sut.doLogout();

      verify(() => firebaseLoginManagement.logout()).called(1);
    });
  });

  group("Go to web customers if still logged", () {
    test("Should call navigateTo web customers when is logged", () async {
      await sut.goToWebCustomersIfStillLogged();

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.webEnterprises))
          .called(1);
    });
    test("Should NOT call navigateTo web customers when is NOT logged",
        () async {
      firebaseLoginManagement.mockIsLoggedIn(false);

      await sut.goToWebCustomersIfStillLogged();

      verifyNever(
        () => navigateTo.navigate(pageRoute: PageRoutes.webEnterprises),
      );
    });
    test("Should close the current page", () async {
      await sut.goToWebCustomersIfStillLogged();

      verify(() => navigateTo.closePage()).called(1);
    });
  });
}
