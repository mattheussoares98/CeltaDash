import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:celta_plus/ui/pages/web_enterprises/web_enterprises.dart';
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

  late List<FirebaseEnterpriseEntity> firebaseEnterprises;
  late MockedFirebaseGet mockedFirebaseGet;
  late DocumentReferenceFake docRef;
  late String bsUserName;
  late String bsPassword;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
    remoteLogin = RemoteLoginSpy();
  }

  void initPresenters() {
    sut = GetxWebEnterprisesPresenter(
      navigateTo: navigateTo,
      firebaseManager: firebaseManager,
      remoteLogin: remoteLogin,
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
  }

  void initMockSuccess() {}

  setUp(() {
    initEntities();
    initUsecases();
    initPresenters();
    initMockSuccess();
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
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: baseUrl,
        enterpriseName: docRef.id,
        docRef: docRef,
      );

      verify(() => firebaseManager.put(
            documentReference: docRef,
            data: {"baseUrl": baseUrl, "enterpriseName": docRef.id},
          )).called(1);
    });
    test("Should save url without spaces and convert to lowercase", () async {
      final baseUrl = faker.lorem.sentence();

      await sut.addNewEnterprise(
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
            },
          )).called(1);
    });
    test("Should save the new enterprise locally", () async {
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
          firebaseSubEnterprises: null,
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
        bsUserName: bsUserName,
        bsPassword: bsPassword,
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: mockedFirebaseGet.docs.first.data()!["enterpriseName"]!,
        docRef: docRef,
      );
    });
  });
}
