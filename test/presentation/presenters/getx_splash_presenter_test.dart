import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/infra/helpers/helpers.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  // ignore: unused_local_variable
  late GetxSplashPresenter sut;

  late NavigateToSpy navigateTo;
  late LocalStorageSpy localStorage;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    localStorage = LocalStorageSpy();
  }

  void initPresenters() {
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      localStorage: localStorage,
    );
  }

  void initEntities() {}

  void initMockSuccess() {
    localStorage.mockGet(
      EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity()).toJson(),
    );
  }

  setUp(() {
    initEntities();
    initUsecases();
    initPresenters();
    initMockSuccess();
  });

  setUpAll(() {
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }
  });

  test("Should navigate to login page if user is null", () async {
    localStorage.mockGet(
      EnterpriseModel.fromEntity(
        EntityFactory.anullEnterpriseProperties(annullUser: true),
      ).toJson(),
    );

    await sut.checkPageToGo(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true),
    ).called(1);
  });
  test("Should navigate to login page if accessKey is null", () async {
    localStorage.mockGet(
      EnterpriseModel.fromEntity(
        EntityFactory.anullEnterpriseProperties(annullAccessKey: true),
      ).toJson(),
    );

    await sut.checkPageToGo(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true),
    ).called(1);
  });
  test("Should load local enterprise", () async {
    await sut.checkPageToGo(durationInSeconds: 0);

    verify(() => localStorage.get(DatabaseKeys.enterprise)).called(1);
  });

  test("Should update EnterpriseBuilder.entity correctly", () async {
    final newEnterprise = EntityFactory.makeEnterpriseEntity();

    localStorage.mockGet(EnterpriseModel.fromEntity(newEnterprise).toJson());

    await sut.checkPageToGo(durationInSeconds: 0);

    expect(EnterpriseBuilder.entity, newEnterprise);
  });
  test("Should update EnterpriseBuilder.entity correctly when return null", () async {
    localStorage.mockGet(null);

    await sut.checkPageToGo(durationInSeconds: 0);

    expect(EnterpriseBuilder.entity, null);
  });
}
