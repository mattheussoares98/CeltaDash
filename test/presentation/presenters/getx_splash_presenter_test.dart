import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
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
  late GetxSplashPresenter sut;

  late EnterprisesManagerPresenterSpy enterprisesManagerPresenter;

  late NavigateToSpy navigateTo;
  late GetPlatformTypeSpy getPlatform;
  late LoadDeviceDataSpy loadDeviceData;
  late FirebaseManagerSpy firebaseManager;

  late MockedFirebaseGet mockedFirebaseGet;
  late String requiredAppVersion;

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
    requiredAppVersion =
        "${faker.randomGenerator.integer(100)}.${faker.randomGenerator.integer(100)}.${faker.randomGenerator.integer(100)}";
    mockedFirebaseGet = MockedFirebaseGet(dataToReturn: [
      FakeDoc({"version": requiredAppVersion}, "id")
    ]);
  }

  void initMockSuccess() {
    getPlatform.mockGet(PlatformType.android);
    loadDeviceData.mockGetAppVersion(requiredAppVersion);
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

  group("Go to update app version page", () {
    test("Should verify app version", () async {
      await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
      );

      verify(() => loadDeviceData.getAppVersion()).called(1);
    });
    test("Should verify required firebase version", () async {
      await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
      );

      verify(() => firebaseManager.get(path: "requiredVersion/version"))
          .called(1);
    });

    test("Should go to update version page if required is greater", () async {
      final major = faker.randomGenerator.integer(100);
      final minor = faker.randomGenerator.integer(100);
      final patch = faker.randomGenerator.integer(100);

      firebaseManager.mockGet(MockedFirebaseGet(dataToReturn: [
        FakeDoc({"required": "$major.$minor.${patch + 1}"}, "version")
      ]));
      loadDeviceData.mockGetAppVersion("$major.$minor.$patch");

      await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
      );

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.updateAppVersion,
          clear: true,
        ),
      ).called(1);
    });
    test("Should NOT go to update version page if required is smaller",
        () async {
      final major = faker.randomGenerator.integer(100);
      final minor = faker.randomGenerator.integer(100);
      final patch = faker.randomGenerator.integer(100);

      firebaseManager.mockGet(MockedFirebaseGet(dataToReturn: [
        FakeDoc({"required": "$major.$minor.$patch"}, "version")
      ]));
      loadDeviceData.mockGetAppVersion("$major.$minor.${patch + 1}");

      await sut.checkPageToGo(
        enterprisesManagerPresenter: enterprisesManagerPresenter,
      );

      verifyNever(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.updateAppVersion,
          clear: true,
        ),
      );
    });
  });
}
