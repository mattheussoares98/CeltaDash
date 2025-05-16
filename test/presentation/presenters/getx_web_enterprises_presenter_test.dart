import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
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
  late GetxWebEnterprisesPresenter sut;

  late NavigateToSpy navigateTo;
  late FirebaseManagerSpy firebaseManager;

  late List<FirebaseEnterpriseEntity> firebaseEnterprises;
  late MockedFirebaseGet mockedFirebaseGet;
  late DocumentReferenceFake docRef;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
  }

  void initPresenters() {
    sut = GetxWebEnterprisesPresenter(
      navigateTo: navigateTo,
      firebaseManager: firebaseManager,
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
  });
}
