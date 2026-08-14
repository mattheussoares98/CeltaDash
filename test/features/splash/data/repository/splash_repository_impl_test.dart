import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/features/splash/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class MockDeviceService extends Mock implements IDeviceService {}

class MockVersionDatasource extends Mock implements IVersionDatasource {}

class MockSplashSessionDatasource extends Mock
    implements ISplashSessionDatasource {}

void main() {
  late MockDeviceService mockDeviceService;
  late MockVersionDatasource mockVersionDatasource;
  late MockSplashSessionDatasource mockSplashSessionDatasource;
  late SplashRepositoryImpl repository;

  setUp(() {
    mockDeviceService = MockDeviceService();
    mockVersionDatasource = MockVersionDatasource();
    mockSplashSessionDatasource = MockSplashSessionDatasource();
    repository = SplashRepositoryImpl(
      deviceService: mockDeviceService,
      versionDatasource: mockVersionDatasource,
      sessionDatasource: mockSplashSessionDatasource,
    );
  });

  group('SplashRepositoryImpl - isUpdateRequired', () {
    test(
      'should return true when local version is lower than remote version',
      () async {
        when(
          () => mockDeviceService.getAppVersion(),
        ).thenAnswer((_) async => '1.0.0');
        when(
          () => mockVersionDatasource.getRequiredVersion(),
        ).thenAnswer((_) async => '1.2.0');

        final result = await repository.isUpdateRequired();

        expect(result, isTrue);
      },
    );

    test(
      'should return false when local version is equal or greater',
      () async {
        when(
          () => mockDeviceService.getAppVersion(),
        ).thenAnswer((_) async => '1.2.0');
        when(
          () => mockVersionDatasource.getRequiredVersion(),
        ).thenAnswer((_) async => '1.2.0');

        final result = await repository.isUpdateRequired();

        expect(result, isFalse);
      },
    );

    test('should return false when local version is greater', () async {
      when(
        () => mockDeviceService.getAppVersion(),
      ).thenAnswer((_) async => '2.0.0');
      when(
        () => mockVersionDatasource.getRequiredVersion(),
      ).thenAnswer((_) async => '1.9.9');

      final result = await repository.isUpdateRequired();

      expect(result, isFalse);
    });

    test('should return false when remote version is null', () async {
      when(
        () => mockDeviceService.getAppVersion(),
      ).thenAnswer((_) async => '1.0.0');
      when(
        () => mockVersionDatasource.getRequiredVersion(),
      ).thenAnswer((_) async => null);

      final result = await repository.isUpdateRequired();

      expect(result, isFalse);
    });

    test('should return false when a dependency throws', () async {
      when(
        () => mockDeviceService.getAppVersion(),
      ).thenThrow(Exception('device unavailable'));

      final result = await repository.isUpdateRequired();

      expect(result, isFalse);
    });
  });

  group('SplashRepositoryImpl - getSavedEnterprise', () {
    test('should return entity from sessionDatasource', () async {
      final enterprise = EntityFactory.makeFirebaseEnterpriseEntity();

      when(
        () => mockSplashSessionDatasource.getSavedEnterprise(),
      ).thenAnswer((_) async => enterprise);

      final result = await repository.getSavedEnterprise();

      expect(result, equals(enterprise));
      verify(() => mockSplashSessionDatasource.getSavedEnterprise()).called(1);
    });

    test('should propagate session datasource failures', () async {
      final exception = Exception('session unavailable');
      when(
        () => mockSplashSessionDatasource.getSavedEnterprise(),
      ).thenThrow(exception);

      expect(repository.getSavedEnterprise, throwsA(same(exception)));
    });
  });
}
