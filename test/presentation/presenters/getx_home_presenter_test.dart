import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
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
  late ProductsPresenterSpy productsPresenter;

  late NavigateToSpy navigateTo;
  late EcLoadEnterprisesSpy ecLoadEnterprises;
  late FirebaseManagerSpy firebaseManager;
  late LocalStorageSpy localStorage;

  late List<EcEnterpriseEntity> enterprisesInBs;
  late MockedFirebaseGet mockedFirebaseGet;
  late DocumentReferenceFake docRef;
  late FirebaseEnterpriseEntity enterpriseOnLogout;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    ecLoadEnterprises = EcLoadEnterprisesSpy();
    localStorage = LocalStorageSpy();
    firebaseManager = FirebaseManagerSpy(
      mockedFirebaseGet: mockedFirebaseGet,
    );
  }

  void initPresenters() {
    sut = GetxHomePresenter(
      navigateTo: navigateTo,
      ecLoadEnterprises: ecLoadEnterprises,
      firebaseManager: firebaseManager,
      localStorage: localStorage,
    );
    salesPresenter = SalesPresenterSpy();
    resumePresenter = ResumePresenterSpy();
    productsPresenter = ProductsPresenterSpy();
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    enterprisesInBs = [
      EntityFactory.makeEcEnterpriseEntity(),
      EntityFactory.makeEcEnterpriseEntity(),
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
    enterpriseOnLogout = FirebaseEnterpriseEntity(
      baseUrl: null,
      firebaseSubEnterprises: null,
      firebaseId: null,
      enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
      bsUser: BsUserEntity(
        name: EnterpriseBuilder.entity?.bsUser?.name,
        AccessKey: null,
        CrossIdentity_Usuario: null,
      ),
    );
  }

  void initMockSuccess() {
    ecLoadEnterprises.mockGet(enterprisesInBs);
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
      sut.goToOperatorsPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.operators),
      ).called(1);
    });
    test("Should go to sellers page", () {
      sut.goToSellersPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.sellers),
      ).called(1);
    });
    test("Should go to profitability page", () {
      sut.goToProfitabilityPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.profitability),
      ).called(1);
    });
    test("Should go to canceled sales page", () {
      sut.goToCanceledSalesPage();

      verify(
        () => navigateTo.navigate(pageRoute: PageRoutes.canceledSales),
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

      ecLoadEnterprises.mockGetError();

      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});
    });

    test("Should update selected enterprise correctly", () async {
      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

      expect(
        sut.selectedEnterprise,
        EcEnterpriseModel.fromEntity(enterprisesInBs.first).toViewModel(),
      );
    });

    test("Should call remoteLoadEnterprises", () async {
      await sut.getBsEnterprises(docRef: docRef, showBsErrorMessage: (_) {});

      verify(() => ecLoadEnterprises.get()).called(1);
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
        ecLoadEnterprises.mockGet(
          EnterpriseBuilder.entity!.firebaseSubEnterprises!
              .map(
                (e) => EcEnterpriseEntity(
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
        ecLoadEnterprises.mockGet(
          EnterpriseBuilder.entity!.firebaseSubEnterprises!
              .map(
                (e) => EcEnterpriseEntity(
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
                  .map((e) => EcEnterpriseModel.fromEntity(e).toJson())
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
        EcEnterpriseModel.fromEntity(EntityFactory.makeEcEnterpriseEntity(
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

      final enterprise = EcEnterpriseModel.fromEntity(
        EntityFactory.makeEcEnterpriseEntity(
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
        id: enterpriseId + faker.randomGenerator.integer(10, min: 1), //!= ids
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

      sut.updateSelectedEnterprise(EcEnterpriseModel.fromEntity(
        EntityFactory.makeEcEnterpriseEntity(
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

      sut.updateSelectedEnterprise(EcEnterpriseModel.fromEntity(
        EntityFactory.makeEcEnterpriseEntity(
          id: enterpriseId,
        ),
      ).toViewModel());
    });
  });

  group("Do logout", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.doLogout();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.doLogout();
    });
    test("Should update enterprise correctly", () async {
      await sut.doLogout();

      expect(EnterpriseBuilder.entity, enterpriseOnLogout);
    });
    test("Should call localStorage.put correctly", () async {
      await sut.doLogout();

      verify(() => localStorage.put(
            DatabaseKeys.enterprise,
            FirebaseEnterpriseModel.fromEntity(enterpriseOnLogout).toJson(),
          )).called(1);
    });
    test("Should call navigateTo with correct value", () async {
      await sut.doLogout();

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.splash,
            clear: true,
          )).called(1);
    });
  });

  group("Reload sales", () {
    group("Resume presenter", () {
      test("Should call resumePresenter get sales", () async {
        sut.reloadSales(resumePresenter, salesPresenter, productsPresenter);

        verify(() => resumePresenter.getSales(sut)).called(1);
      });

      test("Should call resumePresenter get sales forcing refresh", () async {
        sut.reloadSales(
          resumePresenter,
          salesPresenter,
          productsPresenter,
          forceRefresh: true,
        );

        verify(() => resumePresenter.getSales(sut, forceRefresh: true))
            .called(1);
      });
    });

    group("SalesPresenter", () {
      test("Should call salesPresenter get sales", () async {
        sut.reloadSales(resumePresenter, salesPresenter, productsPresenter);

        verify(() => salesPresenter.getSales(sut)).called(1);
      });

      test("Should call salesPresenter get sales forcing refresh", () async {
        sut.reloadSales(
          resumePresenter,
          salesPresenter,
          productsPresenter,
          forceRefresh: true,
        );

        verify(() => salesPresenter.getSales(sut, forceRefresh: true))
            .called(1);
      });
    });
    group("ProductsPresenter", () {
      test("Should call ProductsPresenter get sales", () async {
        sut.reloadSales(resumePresenter, salesPresenter, productsPresenter);

        verify(() => productsPresenter.getSales(sut)).called(1);
      });

      test("Should call ProductsPresenter get sales forcing refresh", () async {
        sut.reloadSales(
          resumePresenter,
          salesPresenter,
          productsPresenter,
          forceRefresh: true,
        );

        verify(() => productsPresenter.getSales(sut, forceRefresh: true))
            .called(1);
      });
    });
  });
}
