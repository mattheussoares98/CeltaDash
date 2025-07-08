import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:celta_dash/main/services/services.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../data/mocks/mocks.dart';
import '../domain/mocks/mocks.dart';

void main() {
  late GetxAppAnalyticsService sut;
  late FirebaseManagerSpy firebaseManager;
  late LocalStorageSpy localStorage;
  late MockedFirebaseGet mockedFirebaseGet;
  late GetPlatformTypeSpy getPlatformType;

  late ReportType reportType;
  late PeriodType periodType;

  void initDependencies() {
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
    localStorage = LocalStorageSpy();
    getPlatformType = GetPlatformTypeSpy();
    sut = GetxAppAnalyticsService(
      firebaseManager: firebaseManager,
      localStorage: localStorage,
      getPlatform: getPlatformType,
    );
  }

  void initMockSuccess() {
    localStorage.mockGet(DatabaseKeys.monthlyAnalytics, null);
    firebaseManager.mockGet(mockedFirebaseGet);
    getPlatformType.mockGet(PlatformType.android);
  }

  void initTestData() {
    reportType = ReportType.sales;
    periodType = PeriodType.daily;
    mockedFirebaseGet = MockedFirebaseGet(dataToReturn: []);
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
  }

  setUp(() {
    initTestData();
    initDependencies();
    initMockSuccess();
  });

  setUpAll(() {
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }
  });

  Map<String, dynamic> createFakeLocalData({int totalCount = 1}) {
    final entity = MonthlyAnalyticsEntity(
      searchCounts: [
        SearchCountEntity(
          reportType: ReportType.products,
          periodType: PeriodType.monthly,
          count: totalCount,
        ),
      ],
      users: [
        ActiveUserEntity(
          userName: faker.person.name(),
          platform: 'ios',
          lastActive: DateTime.now(),
        ),
      ],
    );
    return MonthlyAnalyticsModel.fromEntity(entity).toJson();
  }

  group('addNewMonthlyAnalytic', () {
    test('Should load get local platform', () async {
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      verify(() => getPlatformType.get()).called(1);
    });
    test('Should save the first event locally without syncing to Firebase',
        () async {
      // Arrange: Default setup mocks localStorage.get to return null

      // Act
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      verify(() => localStorage.get(DatabaseKeys.monthlyAnalytics)).called(1);
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verifyNever(() => firebaseManager.put(
            path: any(named: "path"),
            data: any(named: "data"),
            merge: any(named: "merge"),
          ));
    });

    test(
        'Should update local data without syncing when total count is below threshold',
        () async {
      // Arrange
      final localData = createFakeLocalData(totalCount: 3);
      localStorage.mockGet(DatabaseKeys.monthlyAnalytics, localData);

      // Act
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verifyNever(() => firebaseManager.put(
            path: any(named: "path"),
            data: any(named: "data"),
            merge: any(named: "merge"),
          ));
    });

    test('Should sync to Firebase when total count reaches threshold',
        () async {
      // Arrange
      final localData = createFakeLocalData(totalCount: 4);
      localStorage.mockGet(DatabaseKeys.monthlyAnalytics, localData);

      // Act
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verify(() => firebaseManager.put(
            path: any(named: "path"),
            data: any(named: "data"),
            merge: true,
          )).called(1);
    });

    test(
        'Should still sync to Firebase when total count is already over threshold',
        () async {
      // Arrange
      final localData = createFakeLocalData(totalCount: 6);
      localStorage.mockGet(DatabaseKeys.monthlyAnalytics, localData);

      // Act
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verify(() => firebaseManager.put(
            path: any(named: "path"),
            data: any(named: "data"),
            merge: true,
          )).called(1);
    });

    test('Should preserve local data if Firebase sync fails', () async {
      // Arrange
      final localData = createFakeLocalData(totalCount: 4);
      localStorage.mockGet(DatabaseKeys.monthlyAnalytics, localData);
      firebaseManager.mockPutError();

      // Act
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verify(() => firebaseManager.put(
            path: any(named: "path"),
            data: any(named: "data"),
            merge: true,
          )).called(1);
    });

    test('Should complete gracefully if loading local data fails', () async {
      // Arrange
      localStorage.mockGetError(DatabaseKeys.monthlyAnalytics);

      // Act
      final future = sut.addNewMonthlyAnalytic(
        reportType: reportType,
        periodType: periodType,
      );

      // Assert
      await expectLater(future, completes);
      verifyNever(() => localStorage.put(any(), any()));
      verifyNever(() => firebaseManager.put(
          path: any(named: 'path'), data: any(named: 'data')));
    });
  });
}
