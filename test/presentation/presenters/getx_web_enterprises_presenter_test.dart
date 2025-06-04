import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/web_enterprises/web_enterprises.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late GetxWebEnterprisesPresenter sut;

  late NavigateToSpy navigateTo;
  late FirebaseManagerSpy firebaseManager;
  late RemoteLoginSpy remoteLogin;
  late LoadEnterprisesSpy loadEnterprises;

  late List<FirebaseEnterpriseEntity> firebaseEnterprises;
  late MockedFirebaseGet mockedFirebaseGet;
  late DocumentReferenceFake docRef;
  late String bsUserName;
  late String bsPassword;
  late SoapResponseModel bsLoginResponse;
  late List<EnterpriseEntity> enterprisesInBs;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
    remoteLogin = RemoteLoginSpy();
    loadEnterprises = LoadEnterprisesSpy();
  }

  void initPresenters() {
    sut = GetxWebEnterprisesPresenter(
      navigateTo: navigateTo,
      firebaseManager: firebaseManager,
      remoteLogin: remoteLogin,
      loadEnterprises: loadEnterprises,
    );
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    firebaseEnterprises = [
      EntityFactory.makeFirebaseEnterpriseEntity(),
      EntityFactory.makeFirebaseEnterpriseEntity(),
    ];
    mockedFirebaseGet = MockedFirebaseGet(
      dataToReturn: [
        ...firebaseEnterprises.map(
          (e) => FakeDoc(
            FirebaseEnterpriseModel.fromEntity(e).toJson(),
            e.firebaseId!,
          ),
        ),
      ],
    );
    docRef = DocumentReferenceFake();
    bsUserName = faker.internet.userName();
    bsPassword = faker.internet.password();
    bsLoginResponse = SoapResponseModel(
      response:
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!).toJson()
            ..["AccessKey"] = faker.lorem.sentence(),
      responseType: SoapResponseType.success,
    );
    enterprisesInBs = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
  }

  void initMockSuccess() {
    remoteLogin.mockLogin(bsLoginResponse);
    loadEnterprises.mockGet(enterprisesInBs);
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

  group("Load enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(
          sut.enterprisesStream,
          emits(firebaseEnterprises
              .map((e) => FirebaseEnterpriseModel.fromEntity(e).toViewModel())
              .toList()));

      await sut.getEnterprises();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      firebaseManager.mockGetError();

      await sut.getEnterprises();
    });
    test("Should call firebaseManager get with correct values", () async {
      await sut.getEnterprises();

      verify(() => firebaseManager.get(collection: "enterprises")).called(1);
    });
  });

  group("Navigation", () {
    test("Should navigate to web enterprise details correctly", () {
      sut.goToEnterpriseDetails(
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toViewModel());

      verify(() =>
              navigateTo.navigate(pageRoute: PageRoutes.webEnterpriseDetails))
          .called(1);
    });

    test("Should update selected enterprise correctly", () {
      final enterprise = FirebaseEnterpriseModel.fromEntity(
              EntityFactory.makeFirebaseEnterpriseEntity())
          .toViewModel();

      sut.goToEnterpriseDetails(enterprise);
      expect(sut.selectedEnterprise, enterprise);
    });

    test("Should navigate login page correctly", () {
      sut.goToLoginPage();

      verify(() =>
              navigateTo.navigate(pageRoute: PageRoutes.login, clear: true))
          .called(1);
    });
  });

  group("Change enterprise url", () {
    test("Should call firebase manager correctly", () async {
      final enterpriseViewModel =
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toViewModel();
      sut.goToEnterpriseDetails(enterpriseViewModel);
      final newUrl = faker.internet.httpUrl();

      await sut.changeEnterpriseUrl(
        newUrl: newUrl,
        docRef: docRef,
      );

      verify(
        () => firebaseManager.put(
          documentReference: docRef,
          data: {"baseUrl": newUrl},
          merge: true,
        ),
      ).called(1);
    });
    test("Should update selected enterprise correctly", () async {
      final enterpriseViewModel =
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toViewModel();
      sut.goToEnterpriseDetails(enterpriseViewModel);
      final newUrl = faker.internet.httpUrl();

      await sut.changeEnterpriseUrl(
        newUrl: newUrl,
        docRef: docRef,
      );

      expect(sut.selectedEnterprise?.baseUrl, newUrl);
    });

    test("Should not call firebae put when urls are equals", () async {
      final enterpriseViewModel =
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toViewModel();
      sut.goToEnterpriseDetails(enterpriseViewModel);

      await sut.changeEnterpriseUrl(
        newUrl: enterpriseViewModel.baseUrl!,
        docRef: docRef,
      );

      verifyNever(
        () => firebaseManager.put(
          documentReference: docRef,
          data: {"baseUrl": enterpriseViewModel.baseUrl!},
          merge: true,
        ),
      );
    });
    test("Should emit correct error when is the same url", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.sameUrl]));

      final enterpriseViewModel =
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toViewModel();
      sut.goToEnterpriseDetails(enterpriseViewModel);

      await sut.changeEnterpriseUrl(
        newUrl: enterpriseViewModel.baseUrl!,
        docRef: docRef,
      );
    });
    test("Should emit correct values when change enterprise", () async {
      final selectedEnterprise =
          FirebaseEnterpriseModel.fromEntity(firebaseEnterprises.first)
              .toViewModel();
      final enterpriseUpdated = FirebaseEnterpriseViewModel(
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: selectedEnterprise.enterpriseName,
        firebaseSubEnterprises: selectedEnterprise.firebaseSubEnterprises,
        firebaseId: selectedEnterprise.firebaseId,
      );

      final loadedEnterprises = firebaseEnterprises
          .map((e) => FirebaseEnterpriseModel.fromEntity(e).toViewModel())
          .toList();

      final index = loadedEnterprises.indexOf(selectedEnterprise);
      final enterprisesUpdateds = [...loadedEnterprises];
      enterprisesUpdateds[index] = enterpriseUpdated;

      expectLater(
        sut.enterprisesStream,
        emitsInOrder([
          loadedEnterprises,
          enterprisesUpdateds,
        ]),
      );

      await sut.getEnterprises();
      sut.goToEnterpriseDetails(selectedEnterprise);

      await sut.changeEnterpriseUrl(
        newUrl: enterpriseUpdated.baseUrl!,
        docRef: docRef,
      );
    });
  });

  group("Add new enterprise", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpsUrl(),
        enterpriseName: docRef.id,
        docRef: docRef,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      firebaseManager.mockPutError();

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpsUrl(),
        enterpriseName: docRef.id,
        docRef: docRef,
      );
    });
    test("Should call firebase manager with correct values", () async {
      final baseUrl = faker.internet.httpsUrl();

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: baseUrl,
        enterpriseName: docRef.id,
        docRef: docRef,
      );

      verify(() => firebaseManager.put(
            documentReference: docRef,
            data: {
              "baseUrl": baseUrl,
              "enterpriseName": docRef.id,
              "subEnterprises": enterprisesInBs
                  .map((e) => EnterpriseModel.fromEntity(e).toJson())
                  .toList(),
            },
          )).called(1);
    });

    test("Should save url without spaces and convert to lowercase", () async {
      final baseUrl = faker.lorem.sentence();

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: baseUrl,
        enterpriseName: docRef.id,
        docRef: docRef,
      );

      verify(() => firebaseManager.put(
            documentReference: docRef,
            data: {
              "baseUrl": baseUrl.toLowerCase().removeWhiteSpaces(),
              "enterpriseName": docRef.id.toLowerCase().removeWhiteSpaces(),
              "subEnterprises": enterprisesInBs
                  .map((e) => EnterpriseModel.fromEntity(e).toJson())
                  .toList(),
            },
          )).called(1);
    });
    test("Should emit enterprises correctly when add another", () async {
      final oldEnterprises = firebaseEnterprises
          .map((e) => FirebaseEnterpriseModel.fromEntity(e).toViewModel())
          .toList();
      final baseUrl = faker.internet.httpsUrl();
      final newEnterprises = [
        ...oldEnterprises,
        FirebaseEnterpriseViewModel(
          baseUrl: baseUrl.toLowerCase().removeWhiteSpaces(),
          enterpriseName: docRef.id.toLowerCase().removeWhiteSpaces(),
          firebaseId: docRef.id.toLowerCase().removeWhiteSpaces(),
          firebaseSubEnterprises: enterprisesInBs
              .map(
                (e) => FirebaseSubEnterpriseViewModel(
                  id: docRef.id.toLowerCase().removeWhiteSpaces(),
                  name: e.name,
                  personalizedCode: e.personalizedCode,
                  cnpj: e.cnpj,
                  enabled: false.toString(),
                ),
              )
              .toList(),
        ),
      ];

      expectLater(
          sut.enterprisesStream,
          emitsInOrder([
            oldEnterprises,
            newEnterprises,
          ]));

      await sut.getEnterprises();
      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: baseUrl,
        enterpriseName: docRef.id,
        docRef: docRef,
      );
    });

    test("Should emit error when already exists the enterprise", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.enterpriseAlreadyExists]),
      );

      await sut.getEnterprises();
      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: mockedFirebaseGet.docs.first.data()!["enterpriseName"]!,
        docRef: docRef,
      );
    });

    test("Should call remoteLogin with correct values", () async {
      final url = "${faker.internet.httpsUrl().toUpperCase()} anything";

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: url,
        enterpriseName: mockedFirebaseGet.docs.first.data()!["enterpriseName"]!,
        docRef: docRef,
      );

      verify(
        () => remoteLogin.login(
          user: bsUserName,
          password: bsPassword,
          url: url.toLowerCase().removeWhiteSpaces(),
        ),
      ).called(1);
    });

    test("Should emit update bs if access key is null", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.updateCeltaBs]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

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

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: faker.company.name(),
        docRef: docRef,
        bsUserName: bsUserName,
        bsPassword: bsPassword,
      );
    });
    test("Should load enterprises with correct values", () async {
      final baseUrl = "${faker.internet.httpUrl().toUpperCase()} anything";
      final enterpriseName = faker.company.name();

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        docRef: docRef,
        bsUserName: bsUserName,
        bsPassword: bsPassword,
      );

      verify(() => loadEnterprises.get(
            url: baseUrl.toLowerCase().removeWhiteSpaces(),
            userName: bsUserName,
            accessKey: bsLoginResponse.response["AccessKey"],
          )).called(1);
    });
    test("Should add the enterprises got by bsLogin as subenterprises",
        () async {
      final baseUrl = faker.internet.httpUrl();
      final enterpriseName = faker.company.name();

      await sut.addNewEnterprise(
        showBsErrorMessage: (_) {},
        doOnSucceeds: () {},
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        docRef: docRef,
        bsUserName: bsUserName,
        bsPassword: bsPassword,
      );

      verify(
        () => firebaseManager.put(
          documentReference: docRef,
          data: {
            "baseUrl": baseUrl.toLowerCase().removeWhiteSpaces(),
            "enterpriseName": enterpriseName.toLowerCase().removeWhiteSpaces(),
            "subEnterprises": enterprisesInBs
                .map((e) => EnterpriseModel.fromEntity(e).toJson())
                .toList(),
          },
        ),
      ).called(1);
    });
  });

  group("Change enterprise is enabled", () {
    test("Should call with correct values", () async {
      final enterprise = FirebaseEnterpriseViewModel(
        baseUrl: EnterpriseBuilder.entity?.baseUrl,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
        firebaseId: EnterpriseBuilder.entity?.firebaseId,
        firebaseSubEnterprises: [
          FirebaseSubEnterpriseModel.fromEntity(
                  EntityFactory.makeFirebaseSubEnterpriseEntity(enabled: true))
              .toViewModel(),
          FirebaseSubEnterpriseModel.fromEntity(
                  EntityFactory.makeFirebaseSubEnterpriseEntity(enabled: false))
              .toViewModel(),
        ],
      );
      sut.goToEnterpriseDetails(enterprise);
      await sut.changeEnterpriseIsEnabled(
        subEnterpriseIndex: 0,
        docRef: docRef,
      );

      verify(() => firebaseManager.put(
            documentReference: docRef,
            data: FirebaseEnterpriseModel.fromViewModel(
                FirebaseEnterpriseViewModel(
              baseUrl: enterprise.baseUrl,
              enterpriseName: enterprise.enterpriseName,
              firebaseId: enterprise.firebaseId,
              firebaseSubEnterprises: [
                FirebaseSubEnterpriseModel(
                  id: enterprise.firebaseSubEnterprises![0].id?.toInt(),
                  name: enterprise.firebaseSubEnterprises?[0].name,
                  personalizedCode:
                      enterprise.firebaseSubEnterprises?[0].personalizedCode,
                  cnpj: enterprise.firebaseSubEnterprises?[0].cnpj,
                  enabled: false,
                ).toViewModel(),
                FirebaseSubEnterpriseModel(
                  id: enterprise.firebaseSubEnterprises![1].id?.toInt(),
                  name: enterprise.firebaseSubEnterprises?[1].name,
                  personalizedCode:
                      enterprise.firebaseSubEnterprises?[1].personalizedCode,
                  cnpj: enterprise.firebaseSubEnterprises?[1].cnpj,
                  enabled: false,
                ).toViewModel(),
              ],
            )).toJson(),
            merge: false,
          )).called(1);
    });
  });
}
