import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:celta_dash/main/services/services.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../data/mocks/mocks.dart';

void main() {
  // --- Test Dependencies ---
  late GetxAppAnalyticsService sut;
  late FirebaseManagerSpy firebaseManager;
  late LocalStorageSpy localStorage;
  late MockedFirebaseGet mockedFirebaseGet;

  // --- Test Data ---
  late ReportType reportType;
  late ReportPeriod reportPeriod;
  late String userName;
  late String platform;

  // --- Initialization Functions ---
  void initDependencies() {
    // Spies must be initialized before the SUT (System Under Test)
    firebaseManager = FirebaseManagerSpy(mockedFirebaseGet: mockedFirebaseGet);
    localStorage = LocalStorageSpy();
    sut = GetxAppAnalyticsService(
      firebaseManager: firebaseManager,
      localStorage: localStorage,
    );
  }

  void initMockSuccess() {
    // Default mock behavior for successful operations is handled
    // within the spy constructors. We can override here if needed.
    localStorage.mockGet(DatabaseKeys.monthlyAnalytics, null);
    firebaseManager.mockGet(mockedFirebaseGet);
  }

  void initTestData() {
    reportType = ReportType.sales;
    reportPeriod = ReportPeriod.daily;
    userName = faker.person.name();
    platform = 'android';
    mockedFirebaseGet = MockedFirebaseGet(dataToReturn: []);
  }

  setUp(() {
    initTestData();
    initDependencies();
    initMockSuccess();
  });

  setUpAll(() {
    // Register fallback values for any() matchers
    for (var key in DatabaseKeys.values) {
      registerFallbackValue(key);
    }
  });

  // Helper to create a valid JSON map for a MonthlyAnalyticsModel
  Map<String, dynamic> createFakeLocalData({int totalCount = 1}) {
    final entity = MonthlyAnalyticsEntity(
      searchCounts: [
        SearchCountEntity(
          reportType: ReportType.products,
          reportPeriod: ReportPeriod.monthly,
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
    test('Should save the first event locally without syncing to Firebase',
        () async {
      // Arrange: Default setup mocks localStorage.get to return null

      // Act
      await sut.addNewMonthlyAnalytic(
        reportType: reportType,
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );

      // Assert
      verify(() => localStorage.get(DatabaseKeys.monthlyAnalytics)).called(1);
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verifyNever(() => firebaseManager.put(
            documentReference: any(named: "documentReference"),
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
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verifyNever(() => firebaseManager.put(
            documentReference: any(named: "documentReference"),
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
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verify(() => firebaseManager.put(
            documentReference: any(named: "documentReference"),
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
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verify(() => firebaseManager.put(
            documentReference: any(named: "documentReference"),
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
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );

      // Assert
      verify(() => localStorage.put(DatabaseKeys.monthlyAnalytics, any()))
          .called(1);
      verify(() => firebaseManager.put(
            documentReference: any(named: "documentReference"),
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
        reportPeriod: reportPeriod,
        userName: userName,
        platform: platform,
      );

      // Assert
      await expectLater(future, completes);
      verifyNever(() => localStorage.put(any(), any()));
      verifyNever(() => firebaseManager.put(
          documentReference: any(named: 'documentReference'),
          data: any(named: 'data')));
    });
  });
}
