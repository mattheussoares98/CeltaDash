import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
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

  late MockedFirebaseGet mockedFirebaseGet;
  late List<FirebaseEnterpriseEntity> firebaseEnterprisesEntities;
  late String enterpriseName;
  late String userName;
  late String userPassword;
  late BsUserModel bsUserResponse;

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
    enterpriseName = faker.company.name();
    userName = faker.person.name();
    userPassword = faker.internet.password();
    bsUserResponse = BsUserModel.fromEntity(
      EntityFactory.makeBsUserEntity(name: userName),
    );
  }

  void initMockSuccess() {
    bsLogin.mockLogin(bsUserResponse.toJson());
    firebaseManager.mockGet(mockedFirebaseGet);
    localStorage.mockGet(
      DatabaseKeys.enterprise,
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
      final enterprise = FirebaseEnterpriseModel.fromEntity(
          EntityFactory.makeFirebaseEnterpriseEntity());

      await sut.updateSelectedEnterprise(enterprise.toViewModel());
      expect(EnterpriseBuilder.entity, enterprise.toEntity());
    });
    test("Should update selected enterprise in the database", () async {
      final enterprise =
          FirebaseEnterpriseModel.fromEntity(firebaseEnterprisesEntities.first)
              .toViewModel();

      await sut.updateSelectedEnterprise(enterprise);

      verify(
        () => localStorage.put(DatabaseKeys.enterprise,
            FirebaseEnterpriseModel.fromViewModel(enterprise).toJson()),
      ).called(1);
    });
  });

  group("Load local enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadLocalEnterprises();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      localStorage.mockGetError(DatabaseKeys.enterprise);

      await sut.loadLocalEnterprises();
    });
    test("Should load DatabaseKeys.enterprise", () async {
      await sut.loadLocalEnterprises();

      verify(() => localStorage.get(DatabaseKeys.enterprise)).called(1);
    });

    test("Should update selected enterprise correctly", () async {
      final enterprise = FirebaseEnterpriseModel.fromEntity(
        EntityFactory.makeFirebaseEnterpriseEntity(),
      );

      localStorage.mockGet(DatabaseKeys.enterprise, enterprise.toJson());
      await sut.loadLocalEnterprises();

      expect(EnterpriseBuilder.entity, enterprise.toEntity());
    });
    test("Should load all enterprises", () async {
      await sut.loadLocalEnterprises();

      verify(() => localStorage.get(DatabaseKeys.allEnterprises)).called(1);
    });
    test("Should update all enterprises correctly", () async {
      localStorage.mockGet(
        DatabaseKeys.allEnterprises,
        firebaseEnterprisesEntities
            .map((e) => FirebaseEnterpriseModel.fromEntity(e).toJson())
            .toList(),
      );

      await sut.loadLocalEnterprises();

      expect(
          sut.allEnterprises,
          firebaseEnterprisesEntities
              .map((e) => FirebaseEnterpriseModel.fromEntity(e).toViewModel())
              .toList());
    });
  });

  group("Add new enterprise", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      firebaseManager.mockGetError();

      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );
    });
    test("Should emit correct values on firebase data is null", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.enterpriseNotFound]),
      );

      firebaseManager.mockGet(MockedFirebaseGet(dataToReturn: null));

      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );
    });
    test("Should call bsLogin with correct values", () async {
      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );

      verify(() => bsLogin.login(
            user: userName.trimRight(),
            password: userPassword,
            url: mockedFirebaseGet.data()!["baseUrl"],
          )).called(1);
    });
    test("Should emit correct values on bs login return null accessKey",
        () async {
      bsLogin.mockLogin(
        BsUserModel.fromEntity(
          EntityFactory.makeBsUserEntity(),
        ).toJson()
          ..["AccessKey"] = null,
      );

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.updateCeltaBs]),
      );

      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );
    });
    test("Should add the new enterprise in all enterprises", () async {
      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );

      expect(
        sut.allEnterprises,
        [
          FirebaseEnterpriseViewModel(
            baseUrl: mockedFirebaseGet.data()!["baseUrl"],
            enterpriseName: enterpriseName,
            bsUser: bsUserResponse,
            firebaseSubEnterprises: (mockedFirebaseGet.data()!["subEnterprises"]
                    as List?)
                ?.map<FirebaseSubEnterpriseViewModel>(
                    (e) => FirebaseSubEnterpriseModel.fromJson(e).toViewModel())
                .toList(),
            firebaseId: mockedFirebaseGet.id,
          ),
        ],
      );
    });
    test("Should throw error if already exists enterprise with the same name",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.enterpriseAlreadyExists]),
      );

      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );

      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );
    });
    test("Should save all enterprises locally", () async {
      await sut.addNewEnterprise(
        enterpriseName: enterpriseName,
        userName: userName,
        userPassword: userPassword,
      );

      verify(
        () => localStorage.put(
          DatabaseKeys.allEnterprises,
          sut.allEnterprises
              ?.map((e) => FirebaseEnterpriseModel.fromViewModel(e).toJson())
              .toList(),
        ),
      ).called(1);
    });

    test("Should return true on success", () async {
      expect(
        await sut.addNewEnterprise(
          enterpriseName: enterpriseName,
          userName: userName,
          userPassword: userPassword,
        ),
        true,
      );
    });
    test("Should return false on error", () async {
      firebaseManager.mockGetError();

      expect(
        await sut.addNewEnterprise(
          enterpriseName: enterpriseName,
          userName: userName,
          userPassword: userPassword,
        ),
        false,
      );
    });
  });
}
