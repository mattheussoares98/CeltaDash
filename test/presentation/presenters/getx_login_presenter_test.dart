import 'package:celta_dash/domain/entities/entities.dart';
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
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.login(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        enterpriseName: enterpriseName,
        user: user,
        password: password,
      );
    });
  });
  group("On change enterprise name", () {
    test("Should update enterprise correctly when call the funcion", () async {
      sut.onChangedEnterpriseName();

      expect(
        EnterpriseBuilder.entity,
        FirebaseEnterpriseEntity(
          baseUrl: null,
          enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
          firebaseSubEnterprises: null,
          firebaseId: null,
          bsUser: BsUserEntity(
            name: EnterpriseBuilder.entity?.bsUser?.name,
            AccessKey: null,
            CrossIdentity_Usuario: null,
          ),
        ),
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
