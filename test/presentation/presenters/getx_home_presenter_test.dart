import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxHomePresenter sut;

  late SalesPresenterSpy salesPresenter;
  late ResumePresenterSpy resumePresenter;
  late PaymentTypePresenterSpy paymentTypePresenter;
  late ProductsPresenterSpy productsPresenter;
  late DepartmentsPresenterSpy departmentsPresenter;

  late NavigateToSpy navigateTo;
  late LoadEnterprisesSpy loadEnterprises;
  late FirebaseManagerSpy firebaseManager;

  late List<EnterpriseEntity> enterprises;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadEnterprises = LoadEnterprisesSpy();
    firebaseManager = FirebaseManagerSpy(
      mockedFirebaseGet: MockedFirebaseGet(dataToReturn: null),
    );
  }

  void initPresenters() {
    sut = GetxHomePresenter(
      navigateTo: navigateTo,
      loadEnterprises: loadEnterprises,
      firebaseManager: firebaseManager,
    );
    salesPresenter = SalesPresenterSpy();
    resumePresenter = ResumePresenterSpy();
    paymentTypePresenter = PaymentTypePresenterSpy();
    productsPresenter = ProductsPresenterSpy();
    departmentsPresenter = DepartmentsPresenterSpy();
  }

  void initEntities() {
    enterprises = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
  }

  void initMockSuccess() {
    loadEnterprises.mockGet(enterprises);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ResumePresenterSpy());
  });

  group("Change page index", () {
    test("Should update current index correctly", () {
      final first = faker.randomGenerator.integer(100);
      final second = faker.randomGenerator.integer(100);
      final third = faker.randomGenerator.integer(100);
      expectLater(
        sut.currentPageIndexStream,
        emitsInOrder([first, second, third]),
      );

      sut.updateSelectedIndex(first);
      sut.updateSelectedIndex(first);
      sut.updateSelectedIndex(second);
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
    test("Should go to configurations page", () {
      sut.goToConfigurationsPage();

      verify(
        () => navigateTo.navigate(
            pageRoute: PageRoutes.configurations, clear: false),
      ).called(1);
    });
  });

  group("Get enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getBsEnterprises(showBsErrorMessage: (_) {});
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadEnterprises.mockGetError();

      await sut.getBsEnterprises(showBsErrorMessage: (_) {});
    });

    test("Should update selected enterprise correctly", () async {
      await sut.getBsEnterprises(showBsErrorMessage: (_) {});

      expect(
        sut.selectedEnterprise,
        EnterpriseModel.fromEntity(enterprises.first).toViewModel(),
      );
    });
    test("Should not update selected enterprise if already has one selected",
        () async {
      await sut.getBsEnterprises(showBsErrorMessage: (_) {});

      final secondEnterprise =
          EnterpriseModel.fromEntity(enterprises[1]).toViewModel();
      sut.updateSelectedEnterprise(secondEnterprise);

      loadEnterprises.mockGetError();
      await sut.getBsEnterprises(showBsErrorMessage: (_) {});

      expect(sut.selectedEnterprise, secondEnterprise);
    });
    test("Should call remoteLoadEnterprises", () async {
      await sut.getBsEnterprises(showBsErrorMessage: (_) {});

      verify(() => loadEnterprises.get()).called(1);
    });
  });

  group("Update selected enterprise", () {
    test("Should update selected enterprise correctly", () {
      final first = EnterpriseModel.fromEntity(enterprises.first).toViewModel();
      final second = EnterpriseModel.fromEntity(enterprises.last).toViewModel();

      sut.updateSelectedEnterprise(first);
      expect(sut.selectedEnterprise, first);

      sut.updateSelectedEnterprise(second);
      expect(sut.selectedEnterprise, second);

      sut.updateSelectedEnterprise(null);
      expect(sut.selectedEnterprise, null);
    });
    test("Should update selected enterprise correctly", () {
      expectLater(sut.updateScreenStream, emitsInOrder([true, false]));

      sut.updateSelectedEnterprise(
        EnterpriseModel.fromEntity(enterprises.first).toViewModel(),
      );
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
        forceRefresh: forceRefresh,
      );

      verify(() =>
              departmentsPresenter.getSales(sut, forceRefresh: forceRefresh))
          .called(1);
    });
  });
}
