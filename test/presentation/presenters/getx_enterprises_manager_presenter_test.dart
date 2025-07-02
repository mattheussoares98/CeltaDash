import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late GetxEnterprisesManagerPresenter sut;

  late NavigateToSpy navigateTo;
  late BsLoginSpy bsLogin;
  late FirebaseManagerSpy firebaseManager;
  late LocalStorageSpy localStorage;

  late dynamic response;
  late MockedFirebaseGet mockedFirebaseGet;
  late List<FirebaseEnterpriseEntity> firebaseEnterprisesEntities;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    localStorage = LocalStorageSpy();
    navigateTo = NavigateToSpy();
    bsLogin = BsLoginSpy();
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
  }

  void initPresenters() {
    sut = GetxEnterprisesManagerPresenter(
      navigateTo: navigateTo,
      bsLogin: bsLogin,
      firebaseManager: firebaseManager,
      localStorage: localStorage,
    );
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();

    response = FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
        .toJson()
      ..["AccessKey"] = faker.lorem.sentence();
    mockedFirebaseGet = MockedFirebaseGet(
      dataToReturn: [
        FakeDoc(
          FirebaseEnterpriseModel.fromEntity(EnterpriseBuilder.entity!)
              .toJson(),
          EnterpriseBuilder.entity!.firebaseId!,
        )
      ],
    );
    firebaseEnterprisesEntities = [
      EntityFactory.makeFirebaseEnterpriseEntity(),
      EntityFactory.makeFirebaseEnterpriseEntity(),
      EntityFactory.makeFirebaseEnterpriseEntity(),
    ];
  }

  void initMockSuccess() {
    bsLogin.mockLogin(response);
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

  group("Update selected enterprise", () {
    test("Should update selected enterprise correctly", () async {
      final enterprise =
          FirebaseEnterpriseModel.fromEntity(firebaseEnterprisesEntities.first)
              .toViewModel();

      await sut.updateSelectedEnterprise(enterprise);
      expect(sut.selectedEnterprise, enterprise);

      await sut.updateSelectedEnterprise(null);
      expect(sut.selectedEnterprise, null);
    });
    test("Should update selected enterprise in the database", () async {
      final enterprise =
          FirebaseEnterpriseModel.fromEntity(firebaseEnterprisesEntities.first)
              .toViewModel();

      await sut.updateSelectedEnterprise(enterprise);

      verify(
        () => localStorage.put(DatabaseKeys.selectedEnterprise,
            FirebaseEnterpriseModel.fromViewModel(enterprise).toJson()),
      ).called(1);
    });
  });
}
