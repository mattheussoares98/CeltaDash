import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/infra/helpers/helpers.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxConfigurationsPresenter sut;
  late DepartmentsPresenterSpy departmentsPresenter;
  late PaymentTypePresenterSpy paymentTypePresenter;
  late SalesPresenterSpy salesPresenter;
  late ProductsPresenterSpy productsPresenter;
  late ResumePresenterSpy resumePresenter;

  late NavigateToSpy navigateTo;
  late LocalStorageSpy localStorage;

  late FirebaseEnterpriseEntity enterpriseOnLogout;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    localStorage = LocalStorageSpy();
  }

  void initPresenters() {
    sut = GetxConfigurationsPresenter(
      navigateTo: navigateTo,
      localStorage: localStorage,
    );
    departmentsPresenter = DepartmentsPresenterSpy();
    paymentTypePresenter = PaymentTypePresenterSpy();
    salesPresenter = SalesPresenterSpy();
    productsPresenter = ProductsPresenterSpy();
    resumePresenter = ResumePresenterSpy();
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
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

  void initMockSuccess() {}

  setUp(() {
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }

    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ResumePresenterSpy());
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
    test("Should clear data in all presenters", () async {
      await sut.doLogout();

      verify(() => departmentsPresenter.clear()).called(1);
      verify(() => paymentTypePresenter.clear()).called(1);
      verify(() => salesPresenter.clear()).called(1);
      verify(() => productsPresenter.clear()).called(1);
      verify(() => resumePresenter.clear()).called(1);
    });
  });
}
