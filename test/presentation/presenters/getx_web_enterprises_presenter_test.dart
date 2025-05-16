import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/presentation/presenters/presenters.dart';
import 'package:celta_plus/ui/helpers/helpers.dart';

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

  group("Load customers", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(
          sut.enterprisesStream,
          emits(firebaseEnterprises
              .map((e) => FirebaseEnterpriseModel.fromEntity(e).toViewModel())
              .toList()));

      await sut.getCustomers();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      firebaseManager.mockGetError();

      await sut.getCustomers();
    });
    test("Should call firebaseManager get with correct values", () async {
      await sut.getCustomers();

      verify(() => firebaseManager.get(collection: "enterprises")).called(1);
    });
  });
}
