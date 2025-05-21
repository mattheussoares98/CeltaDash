import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/infra/helpers/helpers.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;

  late NavigateToSpy navigateTo;
  late RemoteLoginSpy remoteLogin;
  late FirebaseManagerSpy firebaseManager;
  late LocalStorageSpy localStorage;

  late String enterpriseName;
  late String user;
  late String password;
  late SoapResponseModel response;
  late MockedFirebaseGet mockedFirebaseGet;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    localStorage = LocalStorageSpy();
    navigateTo = NavigateToSpy();
    remoteLogin = RemoteLoginSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
  }

  void initPresenters() {
    sut = GetxLoginPresenter(
      navigateTo: navigateTo,
      remoteLogin: remoteLogin,
      firebaseManager: firebaseManager,
      localStorage: localStorage,
    );
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    enterpriseName = faker.company.name();
    user = faker.person.name();
    password = faker.internet.password();

    response = SoapResponseModel(
      response:
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson()
            ..["AccessKey"] = faker.lorem.sentence(),
      responseType: SoapResponseType.success,
    );
    mockedFirebaseGet = MockedFirebaseGet(
      dataToReturn: [
        FakeDoc(
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toJson(),
          EnterpriseBuilder.entity!.firebaseId!,
        )
      ],
    );
  }

  void initMockSuccess() {
    remoteLogin.mockLogin(response);
    firebaseManager.mockGet(mockedFirebaseGet);
    localStorage.mockGet(
      FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson(),
    );
  }

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
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      remoteLogin.mockLoginError();

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );
    });

    test("Should emit correct values if dont found the enterprise in firebase",
        () async {
      EnterpriseBuilder.entity = EntityFactory.anullEnterpriseProperties(
        annullbaseUrl: true,
      );
      firebaseManager.mockGet(MockedFirebaseGet(
        dataToReturn: null,
      ));

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.enterpriseNotFound]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );
    });

    test("Should get enterprise in firebase if dont has urlCcs", () async {
      EnterpriseBuilder.entity = EntityFactory.anullEnterpriseProperties(
        annullbaseUrl: true,
      );

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verify(
        () => firebaseManager.get(
            collection: "enterprises",
            doc: enterpriseName.toLowerCase().removeWhiteSpaces()),
      ).called(1);
    });
    test("Should not get enterprise in firebase if has urlCcs", () async {
      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verifyNever(
        () => firebaseManager.get(
            collection: "enterprises",
            doc: enterpriseName.toLowerCase().removeWhiteSpaces()),
      );
    });
    test("Should not call remoteLogin if firebaseData is null", () async {
      EnterpriseBuilder.entity = EntityFactory.anullEnterpriseProperties(
        annullbaseUrl: true,
      );

      firebaseManager
          .mockGet(MockedFirebaseGet(dataToReturn: [FakeDoc(null, null)]));

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verifyNever(() => remoteLogin.login(user: user, password: password));
    });

    test("Should call RemoteLogin with correct values", () async {
      await sut.login(
        enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verify(() => remoteLogin.login(user: user, password: password)).called(1);
    });

    test("Should not call remote login if firebaseManager throws", () async {
      EnterpriseBuilder.entity = EntityFactory.anullEnterpriseProperties(
        annullbaseUrl: true,
      );

      firebaseManager.mockGetError();

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verifyNever(() => remoteLogin.login(user: user, password: password));
    });
    test("Should navigate to home page", () async {
      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true),
      ).called(1);
    });

    test("Should not navigate to home page if soap response is error",
        () async {
      remoteLogin.mockLogin(
        SoapResponseModel(
          response: faker.randomGenerator.string(10),
          responseType: SoapResponseType.error,
        ),
      );

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verifyNever(() => navigateTo.navigate(pageRoute: PageRoutes.home));
    });

    test("Should save enterprise locally in success", () async {
      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verify(
        () => localStorage.put(
            DatabaseKeys.enterprise,
            FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
                .toJson()),
      ).called(1);
    });
    test("Should update EnterpriseBuilder correctly when login is successful",
        () async {
      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      expect(
        EnterpriseBuilder.entity,
        FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
            .toEntity(),
      );
    });
    test("Should update EnterpriseBuilder correctly when login bs throws",
        () async {
      EnterpriseBuilder.entity =
          EntityFactory.anullEnterpriseProperties(annullbaseUrl: true);

      remoteLogin.mockLogin(
        SoapResponseModel(
          response: faker.lorem.sentence(),
          responseType: SoapResponseType.error,
        ),
      );

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );
      mockedFirebaseGet = MockedFirebaseGet(
        dataToReturn: [
          FakeDoc(
            FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
                .toJson(),
            EnterpriseBuilder.entity!.firebaseId!,
          )
        ],
      );
      expect(
        EnterpriseBuilder.entity,
        FirebaseEnterpriseEntity(
          baseUrl: mockedFirebaseGet.data()!["baseUrl"],
          firebaseId: mockedFirebaseGet.id,
          firebaseSubEnterprises: mockedFirebaseGet
              .data()!["subEnterprises"]
              ?.map<FirebaseSubEnterpriseEntity>(
                  (e) => FirebaseSubEnterpriseModel.fromJson(e).toEntity())
              .toList(),
          bsUser: BsUserEntity(
            name: user,
            AccessKey: null,
            CrossIdentity_Usuario: null,
          ),
          enterpriseName: enterpriseName,
        ),
      );
    });

    test("Should not do login if dont receive accessKey", () async {
      EnterpriseBuilder.entity =
          EntityFactory.anullEnterpriseProperties(annullbaseUrl: true);

      remoteLogin.mockLogin(
        SoapResponseModel(
          response:
              FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
                  .toJson()
                ..["AccessKey"] = null,
          responseType: SoapResponseType.success,
        ),
      );

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verifyNever(() => navigateTo.navigate(pageRoute: PageRoutes.login));
    });
    test("Should emit correct error when dont receive AccesKey", () async {
      EnterpriseBuilder.entity =
          EntityFactory.anullEnterpriseProperties(annullbaseUrl: true);

      remoteLogin.mockLogin(
        SoapResponseModel(
          response:
              FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
                  .toJson()
                ..["AccessKey"] = null,
          responseType: SoapResponseType.success,
        ),
      );

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.updateCeltaBs]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.login(
        enterpriseName: enterpriseName,
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verifyNever(() => navigateTo.navigate(pageRoute: PageRoutes.login));
    });
    test("Should remove white spaces after last name", () async {
      final user = "${faker.person.name()}  ${faker.person.name()}";

      await sut.login(
        enterpriseName: enterpriseName,
        user: "$user  ",
        password: password,
        showBsErrorMessage: (_) {},
      );

      verify(
        () => remoteLogin.login(user: user, password: password),
      ).called(1);
    });
    test("Should update customer name correctly in Entity", () async {
      final user = "${faker.person.name()}  ${faker.person.name()}";

      await sut.login(
        enterpriseName: enterpriseName,
        user: "$user  ",
        password: password,
        showBsErrorMessage: (_) {},
      );

      expect(EnterpriseBuilder.entity?.bsUser?.name, user.trimRight());
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
