import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/infra/helpers/helpers.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late GetxHomePresenter sut;

  late SalesPresenterSpy salesPresenter;
  late ResumePresenterSpy resumePresenter;
  late PaymentTypePresenterSpy paymentTypePresenter;
  late ProductsPresenterSpy productsPresenter;
  late DepartmentsPresenterSpy departmentsPresenter;
  late OperatorsProductivityPresenterSpy operatorsProductivityPresenter;

  late NavigateToSpy navigateTo;
  late LoadEnterprisesSpy loadEnterprises;
  late FirebaseManagerSpy firebaseManager;
  late LocalStorageSpy localStorage;

  late List<EnterpriseEntity> enterprisesInBs;
  late MockedFirebaseGet mockedFirebaseGet;
  late DocumentReferenceFake docRef;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadEnterprises = LoadEnterprisesSpy();
    localStorage = LocalStorageSpy();
    firebaseManager = FirebaseManagerSpy(
      mockedFirebaseGet: mockedFirebaseGet,
    );
  }

  void initPresenters() {
    sut = GetxHomePresenter(
      navigateTo: navigateTo,
      loadEnterprises: loadEnterprises,
      firebaseManager: firebaseManager,
      localStorage: localStorage,
    );
    salesPresenter = SalesPresenterSpy();
    resumePresenter = ResumePresenterSpy();
    paymentTypePresenter = PaymentTypePresenterSpy();
    productsPresenter = ProductsPresenterSpy();
    departmentsPresenter = DepartmentsPresenterSpy();
    operatorsProductivityPresenter = OperatorsProductivityPresenterSpy();
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    enterprisesInBs = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
    mockedFirebaseGet = MockedFirebaseGet(
      dataToReturn: [
        FakeDoc(
            FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
                .toJson(),
            EnterpriseBuilder.entity!.firebaseId!)
      ],
    );
    docRef = DocumentReferenceFake();
  }

  void initMockSuccess() {
    loadEnterprises.mockGet(enterprisesInBs);
    firebaseManager.mockGet(mockedFirebaseGet);
  }

  setUp(() {
    initEntities();
    initUsecases();
    initMockSuccess();
    initPresenters();
  });

  setUpAll(() async {
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ResumePresenterSpy());
    registerFallbackValue(EntityFactory.makeFirebaseEnterpriseEntity());
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }
  });

  group("Change page index", () {
    test("Should update current index correctly", () {
      final first = faker.randomGenerator.integer(100);
      final second = faker.randomGenerator.integer(100);
      final third = faker.randomGenerator.integer(100);
      expectLater(
        sut.currentPageIndexStream,
        emitsInOrder([first, second, third, third]),
      );

      sut.updateSelectedIndex(first);
      sut.updateSelectedIndex(second);
      sut.updateSelectedIndex(third);
      sut.updateSelectedIndex(third);
    });
  });

  group("Update selected date", () {
    test("Should emit update screen", () {
      expectLater(sut.updateScreenStream, emitsInOrder([true, false]));

      sut.updateSelectedDate(faker.date.dateTime());
    });
    test("Should update date correctly", () {
      final firstDate = faker.date.dateTime();
      final secondDate = faker.date.dateTime();

      sut.updateSelectedDate(firstDate);
      expect(sut.selectedDate, firstDate);

      sut.updateSelectedDate(secondDate);
      expect(sut.selectedDate, secondDate);
    });
  });

  group("Navigation", () {
    test("Should go to operators page", () {
      sut.goToOperatorsProductivityPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.operatorsProductivity),
      ).called(1);
    });
    test("Should go to sellers page", () {
      sut.goToSellersPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.sellers),
      ).called(1);
    });
  });

  group("Get enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadEnterprises.mockGetError();

      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});
    });

    test("Should update selected enterprise correctly", () async {
      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

      expect(
        sut.selectedEnterprise,
        EnterpriseModel.fromEntity(enterprisesInBs.first).toViewModel(),
      );
    });

    test("Should call remoteLoadEnterprises", () async {
      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

      verify(() => loadEnterprises.get()).called(1);
    });

    group("Update sub enterprises in firebase", () {
      test(
          "Should get firebase sub enterprises if is missing enterprises locally",
          () async {
        await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

        verify(
          () => firebaseManager.get(
            collection: "enterprises",
            doc: EnterpriseBuilder.entity?.firebaseId,
          ),
        ).called(1);
      });
      test(
          "Should NOT get firebase sub enterprises if is not missing enterprises locally",
          () async {
        loadEnterprises.mockGet(
          EnterpriseBuilder.entity!.firebaseSubEnterprises!
              .map(
                (e) => EnterpriseEntity(
                  id: e.id,
                  name: e.name,
                  personalizedCode: e.personalizedCode,
                  cnpj: e.cnpj,
                ),
              )
              .toList(),
        );

        await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

        verifyNever(
          () => firebaseManager.get(
            collection: "enterprises",
            doc: EnterpriseBuilder.entity?.firebaseId,
          ),
        );
      });
      test("Should update add missing enterprises in firebase", () async {
        await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

        verify(
          () => firebaseManager.put(
              documentReference: docRef,
              merge: true,
              data: {},
              arrayUnion: [
                {
                  "subEnterprises": FieldValue.arrayUnion(
                    enterprisesInBs
                        .map((e) => FirebaseSubEnterpriseModel.fromEntity(
                                FirebaseSubEnterpriseEntity(
                              id: e.id,
                              name: e.name,
                              personalizedCode: e.personalizedCode,
                              cnpj: e.cnpj,
                              enabled: false,
                            )).toJson())
                        .toList(),
                  ),
                }
              ]),
        ).called(1);
      });
      test("Should no call to put enterprises if is not missing", () async {
        loadEnterprises.mockGet(
          EnterpriseBuilder.entity!.firebaseSubEnterprises!
              .map(
                (e) => EnterpriseEntity(
                  id: e.id,
                  name: e.name,
                  personalizedCode: e.personalizedCode,
                  cnpj: e.cnpj,
                ),
              )
              .toList(),
        );

        await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

        verifyNever(
          () => firebaseManager.put(
            documentReference: docRef,
            merge: true,
            data: {
              "subEnterprises": enterprisesInBs
                  .map((e) => EnterpriseModel.fromEntity(e).toJson())
                  .toList()
            },
          ),
        );
      });
      test("Should update enterprise locally", () async {
        await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

        verify(
          () => localStorage.put(
            DatabaseKeys.enterprise,
            FirebaseEnterpriseModel.fromEntity(
              FirebaseEnterpriseEntity(
                baseUrl: EnterpriseBuilder.entity?.baseUrl,
                enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
                bsUser: EnterpriseBuilder.entity?.bsUser,
                firebaseId: EnterpriseBuilder.entity?.firebaseId,
                firebaseSubEnterprises:
                    EnterpriseBuilder.entity!.firebaseSubEnterprises,
              ),
            ).toJson(),
          ),
        );
      });
      test("Should update EnterpriseBuilder correctly", () async {
        final oldEnterprises = [
          ...EnterpriseBuilder.entity!.firebaseSubEnterprises!
        ];

        await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

        expect(
          EnterpriseBuilder.entity,
          FirebaseEnterpriseEntity(
            baseUrl: EnterpriseBuilder.entity?.baseUrl,
            enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
            bsUser: EnterpriseBuilder.entity?.bsUser,
            firebaseId: EnterpriseBuilder.entity?.firebaseId,
            firebaseSubEnterprises: [
              ...oldEnterprises,
              ...enterprisesInBs.map(
                (e) => FirebaseSubEnterpriseEntity(
                  id: e.id,
                  name: e.name,
                  personalizedCode: e.personalizedCode,
                  cnpj: e.cnpj,
                  enabled: false,
                ),
              ),
            ],
          ),
        );
      });
    });
  });

  group("Update selected enterprise", () {
    test("Should not update selected enterprise if is not enabled", () {
      final enterpriseId = faker.randomGenerator.integer(100);
      final disabledSubEnterprise =
          EntityFactory.makeFirebaseSubEnterpriseEntity(
        enabled: false,
        id: enterpriseId,
      );

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: EnterpriseBuilder.entity?.baseUrl,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
        bsUser: EnterpriseBuilder.entity?.bsUser,
        firebaseId: EnterpriseBuilder.entity?.firebaseId,
        firebaseSubEnterprises: [disabledSubEnterprise],
      );

      sut.updateSelectedEnterprise(
        EnterpriseModel.fromEntity(EntityFactory.makeEnterpriseEntity(
          id: enterpriseId,
        )).toViewModel(),
      );

      expect(sut.selectedEnterprise, null);
    });
    test("Should update selected enterprise if is enabled", () {
      final enterpriseId = faker.randomGenerator.integer(100);
      final disabledSubEnterprise =
          EntityFactory.makeFirebaseSubEnterpriseEntity(
        enabled: true,
        id: enterpriseId,
      );

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: EnterpriseBuilder.entity?.baseUrl,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
        bsUser: EnterpriseBuilder.entity?.bsUser,
        firebaseId: EnterpriseBuilder.entity?.firebaseId,
        firebaseSubEnterprises: [disabledSubEnterprise],
      );

      final enterprise = EnterpriseModel.fromEntity(
        EntityFactory.makeEnterpriseEntity(
          id: enterpriseId,
        ),
      ).toViewModel();

      sut.updateSelectedEnterprise(enterprise);

      expect(sut.selectedEnterprise, enterprise);
    });
    test(
        "Should emit unexpected error if dont exists enterprise with the same id",
        () {
      final enterpriseId = faker.randomGenerator.integer(100);

      final disabledSubEnterprise =
          EntityFactory.makeFirebaseSubEnterpriseEntity(
        enabled: true,
        id: enterpriseId * faker.randomGenerator.integer(10), //!= ids
      );

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: EnterpriseBuilder.entity?.baseUrl,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
        bsUser: EnterpriseBuilder.entity?.bsUser,
        firebaseId: EnterpriseBuilder.entity?.firebaseId,
        firebaseSubEnterprises: [disabledSubEnterprise],
      );

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      sut.updateSelectedEnterprise(EnterpriseModel.fromEntity(
        EntityFactory.makeEnterpriseEntity(
          id: enterpriseId,
        ),
      ).toViewModel());
    });
    test("Should emit disabled enterprise if is not enabled", () {
      final enterpriseId = faker.randomGenerator.integer(100);

      final disabledSubEnterprise =
          EntityFactory.makeFirebaseSubEnterpriseEntity(
        enabled: false,
        id: enterpriseId,
      );

      EnterpriseBuilder.entity = FirebaseEnterpriseEntity(
        baseUrl: EnterpriseBuilder.entity?.baseUrl,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
        bsUser: EnterpriseBuilder.entity?.bsUser,
        firebaseId: EnterpriseBuilder.entity?.firebaseId,
        firebaseSubEnterprises: [disabledSubEnterprise],
      );

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.disabledEnterprise]),
      );

      sut.updateSelectedEnterprise(EnterpriseModel.fromEntity(
        EntityFactory.makeEnterpriseEntity(
          id: enterpriseId,
        ),
      ).toViewModel());
    });
  });

  group("Need update screen", () {
    test("Should emit correct values", () {
      expectLater(sut.updateScreenStream, emitsInOrder([true, false]));

      sut.updateScreen();
    });
  });

  group("Reload all data", () {
    test("Should call sales presenter get sales", () {
      final forceRefresh = faker.randomGenerator.boolean();

      sut.reloadAllData(
        salesPresenter,
        resumePresenter,
        paymentTypePresenter,
        productsPresenter,
        departmentsPresenter,
        operatorsProductivityPresenter,
        forceRefresh: forceRefresh,
      );

      verify(() => salesPresenter.getSales(
          homePresenter: sut,
          resumePresenter: resumePresenter,
          forceRefresh: forceRefresh)).called(1);
    });
    test("Should call resume presenter get sales", () {
      final forceRefresh = faker.randomGenerator.boolean();

      sut.reloadAllData(
        salesPresenter,
        resumePresenter,
        paymentTypePresenter,
        productsPresenter,
        departmentsPresenter,
        operatorsProductivityPresenter,
        forceRefresh: forceRefresh,
      );

      verify(() => resumePresenter.getSales(sut, forceRefresh: forceRefresh))
          .called(1);
    });
    test("Should call paymet type presenter get sales", () {
      final forceRefresh = faker.randomGenerator.boolean();

      sut.reloadAllData(
        salesPresenter,
        resumePresenter,
        paymentTypePresenter,
        productsPresenter,
        departmentsPresenter,
        operatorsProductivityPresenter,
        forceRefresh: forceRefresh,
      );

      verify(() =>
              paymentTypePresenter.getSales(sut, forceRefresh: forceRefresh))
          .called(1);
    });
    test("Should call products presenter get sales", () {
      final forceRefresh = faker.randomGenerator.boolean();

      sut.reloadAllData(
        salesPresenter,
        resumePresenter,
        paymentTypePresenter,
        productsPresenter,
        departmentsPresenter,
        operatorsProductivityPresenter,
        forceRefresh: forceRefresh,
      );

      verify(() =>
              productsPresenter.loadProducts(sut, forceRefresh: forceRefresh))
          .called(1);
    });
    test("Should call departments presenter get sales", () {
      final forceRefresh = faker.randomGenerator.boolean();

      sut.reloadAllData(
        salesPresenter,
        resumePresenter,
        paymentTypePresenter,
        productsPresenter,
        departmentsPresenter,
        operatorsProductivityPresenter,
        forceRefresh: forceRefresh,
      );

      verify(() =>
              departmentsPresenter.getSales(sut, forceRefresh: forceRefresh))
          .called(1);
    });
    test("Should call operatorsProductivity presenter get sales", () {
      final forceRefresh = faker.randomGenerator.boolean();

      sut.reloadAllData(
        salesPresenter,
        resumePresenter,
        paymentTypePresenter,
        productsPresenter,
        departmentsPresenter,
        operatorsProductivityPresenter,
        forceRefresh: forceRefresh,
      );

      verify(() => operatorsProductivityPresenter.getSales(sut,
          forceRefresh: forceRefresh)).called(1);
    });
  });
}
