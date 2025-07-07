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
  late BsLoginSpy bsLogin;
  late LoadEnterprisesSpy loadEnterprises;

  late List<FirebaseEnterpriseEntity> firebaseEnterprises;
  late MockedFirebaseGet mockedFirebaseGet;
  late String bsUserName;
  late String bsPassword;
  late dynamic bsLoginResponse;
  late List<EnterpriseEntity> enterprisesInBs;
  late String enterpriseName;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
    bsLogin = BsLoginSpy();
    loadEnterprises = LoadEnterprisesSpy();
  }

  void initPresenters() {
    sut = GetxWebEnterprisesPresenter(
      navigateTo: navigateTo,
      firebaseManager: firebaseManager,
      bsLogin: bsLogin,
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
    enterpriseName = faker.company.name();
    bsUserName = faker.internet.userName();
    bsPassword = faker.internet.password();
    bsLoginResponse = BsUserModel(
      name: faker.person.name(),
      AccessKey: faker.guid.guid(),
      CrossIdentity_Usuario: faker.guid.guid(),
    ).toJson();

    enterprisesInBs = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
  }

  void initMockSuccess() {
    bsLogin.mockLogin(bsLoginResponse);
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

      verify(() => firebaseManager.get(path: "enterprises")).called(1);
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

      await sut.changeEnterpriseUrl(newUrl);

      verify(
        () => firebaseManager.put(
          path: "enterprises/${enterpriseViewModel.firebaseId}",
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

      await sut.changeEnterpriseUrl(newUrl);

      expect(sut.selectedEnterprise?.baseUrl, newUrl);
    });

    test("Should not call firebae put when urls are equals", () async {
      final enterpriseViewModel =
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toViewModel();
      sut.goToEnterpriseDetails(enterpriseViewModel);

      await sut.changeEnterpriseUrl(enterpriseViewModel.baseUrl!);

      verifyNever(
        () => firebaseManager.put(
          path: "enterprises/${enterpriseViewModel.firebaseId}",
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

      await sut.changeEnterpriseUrl(enterpriseViewModel.baseUrl!);
    });
    test("Should emit correct values when change enterprise", () async {
      final selectedEnterprise =
          FirebaseEnterpriseModel.fromEntity(firebaseEnterprises.first)
              .toViewModel();
      final enterpriseUpdated = FirebaseEnterpriseViewModel(
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: selectedEnterprise.enterpriseName,
        firebaseSubEnterprises: selectedEnterprise.firebaseSubEnterprises,
        bsUser: selectedEnterprise.bsUser,
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

      await sut.changeEnterpriseUrl(enterpriseUpdated.baseUrl!);
    });
  });

  group("Add new enterprise", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpsUrl(),
        enterpriseName: enterpriseName,
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
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpsUrl(),
        enterpriseName: enterpriseName,
      );
    });
    test("Should call firebase manager with correct values", () async {
      final baseUrl = faker.internet.httpsUrl();

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
      );

      verify(() => firebaseManager.put(
            path:
                "enterprises/${enterpriseName.toLowerCase().removeWhiteSpaces()}",
            data: {
              "baseUrl": baseUrl,
              "enterpriseName":
                  enterpriseName.toLowerCase().removeWhiteSpaces(),
              "subEnterprises": enterprisesInBs
                  .map((e) => EnterpriseModel.fromEntity(e).toJson())
                  .toList(),
            },
          )).called(1);
    });

    test("Should save url without spaces and convert to lowercase", () async {
      final baseUrl = faker.lorem.sentence();

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
      );

      verify(() => firebaseManager.put(
            path:
                "enterprises/${enterpriseName.toLowerCase().removeWhiteSpaces()}",
            data: {
              "baseUrl": baseUrl.toLowerCase().removeWhiteSpaces(),
              "enterpriseName":
                  enterpriseName.toLowerCase().removeWhiteSpaces(),
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

      final newEnterprise = FirebaseEnterpriseViewModel(
        baseUrl: faker.internet.httpsUrl().toLowerCase().removeWhiteSpaces(),
        enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
        firebaseId: enterpriseName.toLowerCase().removeWhiteSpaces(),
        bsUser: BsUserModel.fromJson(bsLoginResponse),
        firebaseSubEnterprises: enterprisesInBs
            .map(
              (e) => FirebaseSubEnterpriseViewModel(
                id: enterpriseName.toLowerCase().removeWhiteSpaces(),
                name: e.name,
                personalizedCode: e.personalizedCode,
                cnpj: e.cnpj,
                enabled: false.toString(),
              ),
            )
            .toList(),
      );
      final updatedEnterprises = [...oldEnterprises, newEnterprise];

      expectLater(
          sut.enterprisesStream,
          emitsInOrder([
            oldEnterprises,
            updatedEnterprises,
          ]));

      await sut.getEnterprises();
      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: newEnterprise.baseUrl!,
        enterpriseName: newEnterprise.enterpriseName!,
      );
    });

    test("Should emit error when already exists the enterprise", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.enterpriseAlreadyExists]),
      );

      await sut.getEnterprises();
      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: mockedFirebaseGet.docs.first.data()!["enterpriseName"]!,
      );
    });

    test("Should call bsLogin with correct values", () async {
      final url = "${faker.internet.httpsUrl().toUpperCase()} anything";

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: url,
        enterpriseName: mockedFirebaseGet.docs.first.data()!["enterpriseName"]!,
      );

      verify(
        () => bsLogin.login(
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

      bsLogin.mockLogin(BsUserModel(
        name: faker.internet.userName(),
        AccessKey: null,
        CrossIdentity_Usuario: faker.guid.guid(),
      ).toJson());

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: faker.company.name(),
        bsUserName: bsUserName,
        bsPassword: bsPassword,
      );
    });
    test("Should load enterprises with correct values", () async {
      final baseUrl = "${faker.internet.httpUrl().toUpperCase()} anything";
      final enterpriseName = faker.company.name();

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        bsUserName: bsUserName,
        bsPassword: bsPassword,
      );

      verify(() => loadEnterprises.get(
            url: baseUrl.toLowerCase().removeWhiteSpaces(),
            userName: bsUserName,
            accessKey: bsLoginResponse["AccessKey"],
          )).called(1);
    });
    test("Should add the enterprises got by bsLogin as subenterprises",
        () async {
      final baseUrl = faker.internet.httpUrl();
      final enterpriseName = faker.company.name();

      await sut.addNewEnterprise(
        doOnSucceeds: () {},
        baseUrl: baseUrl,
        enterpriseName: enterpriseName,
        bsUserName: bsUserName,
        bsPassword: bsPassword,
      );

      verify(
        () => firebaseManager.put(
          path:
              "enterprises/${enterpriseName.toLowerCase().removeWhiteSpaces()}",
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
        bsUser: BsUserModel.fromEntity(EnterpriseBuilder.entity?.bsUser),
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
      await sut.changeEnterpriseIsEnabled(0);

      verify(() => firebaseManager.put(
            path: "enterprises/${enterprise.firebaseId}",
            data: FirebaseEnterpriseModel.fromViewModel(
                FirebaseEnterpriseViewModel(
              baseUrl: enterprise.baseUrl,
              enterpriseName: enterprise.enterpriseName,
              firebaseId: enterprise.firebaseId,
              bsUser: enterprise.bsUser,
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
