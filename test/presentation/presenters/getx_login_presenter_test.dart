import 'package:celta_plus/data/models/models.dart';
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

  late String enterpriseName;
  late String user;
  late String password;
  late SoapResponseModel response;
  late MockedFirebaseGet mockedFirebaseGet;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    remoteLogin = RemoteLoginSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
  }

  void initPresenters() {
    sut = GetxLoginPresenter(
      navigateTo: navigateTo,
      remoteLogin: remoteLogin,
      firebaseManager: firebaseManager,
    );
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseEntity();
    enterpriseName = faker.company.name();
    user = faker.person.name();
    password = faker.internet.password();
    response = SoapResponseModel(
      response: faker.lorem.word(),
      responseType: SoapResponseType.success,
    );
    mockedFirebaseGet = MockedFirebaseGet(
      dataToReturn:
          EnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson(),
    );
  }

  void initMockSuccess() {
    remoteLogin.mockLogin(response);
    firebaseManager.mockGet(mockedFirebaseGet);
  }

  setUp(() {
    initEntities();
    initUsecases();
    initMockSuccess();
    initPresenters();
  });

  setUpAll(() {
    registerFallbackValue("");
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
    test("Should call RemoteLogin with correct values", () async {
      await sut.login(
        enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
        user: user,
        password: password,
        showBsErrorMessage: (_) {},
      );

      verify(() => remoteLogin.login(user: user, password: password)).called(1);
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

    test("Should not navgate to home page if soap response is error", () async {
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
  });
}
