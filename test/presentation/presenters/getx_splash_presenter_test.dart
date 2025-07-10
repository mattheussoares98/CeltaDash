import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;

  late EnterprisesManagerPresenterSpy enterprisesManagerPresenter;

  late NavigateToSpy navigateTo;
  late GetPlatformTypeSpy getPlatform;
  late LoadDeviceDataSpy loadDeviceData;
  late FirebaseManagerSpy firebaseManager;

  late MockedFirebaseGet mockedFirebaseGet;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    getPlatform = GetPlatformTypeSpy();
    loadDeviceData = LoadDeviceDataSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
  }

  void initPresenters() {
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      getPlatform: getPlatform,
      loadDeviceData: loadDeviceData,
      firebaseManager: firebaseManager,
    );
    enterprisesManagerPresenter = EnterprisesManagerPresenterSpy();
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    mockedFirebaseGet = MockedFirebaseGet(dataToReturn: [
      FakeDoc({"version": "1.9.8"}, "id")
    ]);
  }

  void initMockSuccess() {
    getPlatform.mockGet(PlatformType.android);
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
    registerFallbackValue(FirebaseEnterpriseModel.fromEntity(
            EntityFactory.makeFirebaseEnterpriseEntity())
        .toViewModel());
  });

  test("Should navigate to login page if accessKey is null", () async {
    EnterpriseBuilder.entity =
        EntityFactory.anullEnterpriseProperties(anullUserAccessKey: true);

    await sut.checkPageToGo(
      enterprisesManagerPresenter: enterprisesManagerPresenter,
      durationInSeconds: 0,
    );

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true),
    ).called(1);
  });
  test("Should navigate to login page if crossIdentity is null", () async {
    EnterpriseBuilder.entity =
        EntityFactory.anullEnterpriseProperties(anullUserCrossIdentity: true);

    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true),
    ).called(1);
  });
  test("Should navigate to login page if user name is null", () async {
    EnterpriseBuilder.entity =
        EntityFactory.anullEnterpriseProperties(anullUserName: true);

    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true),
    ).called(1);
  });
  test(
      "Should go to login page if enterprise manager load all enterprises fails",
      () async {
    enterprisesManagerPresenter.mockLoadLocalEnterprisesError();

    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login, clear: true),
    ).called(1);
  });
  test("Should call enterprisesManagerPresenter.loadLocalEnterprises",
      () async {
    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(() => enterprisesManagerPresenter.loadLocalEnterprises()).called(1);
  });

  test("Should navigate to all customers page if is web platform", () async {
    getPlatform.mockGet(PlatformType.web);

    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true),
    ).called(1);
  });
  test("Should call verify platform", () async {
    getPlatform.mockGet(PlatformType.web);

    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(() => getPlatform.get()).called(1);
  });
  test("Should load enterprisesManagerPresenter.loadLocallEnterprises",
      () async {
    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(() => enterprisesManagerPresenter.loadLocalEnterprises()).called(1);
  });

  test(
      "Should go to home page if enterprise manager load all enterprises correctly",
      () async {
    await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
        durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true),
    ).called(1);
  });
}
