// test/features/login/presentation/controllers/login_controller_test.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/core/infrastructure/storage/storage.dart';
import 'package:celta_dash/features/login/domain/entities/entities.dart';
import 'package:celta_dash/features/login/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/login/providers.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

class MockLocalStorage extends Mock implements IAppStorage {}

void main() {
  late MockLoginRepository mockRepository;
  late MockLocalStorage mockLocalStorage;
  late ProviderContainer container;

  final tEnterpriseEntity = EntityFactory.makeFirebaseEnterpriseEntity();
  final tParams = LoginParams(
    enterpriseName: tEnterpriseEntity.enterpriseName!,
    user: tEnterpriseEntity.bsUser!.name!,
    password: faker.internet.password(),
  );

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockRepository = MockLoginRepository();
    mockLocalStorage = MockLocalStorage();

    container = ProviderContainer(
      overrides: [
        loginRepositoryProvider.overrideWithValue(mockRepository),
        appStorageProvider.overrideWithValue(mockLocalStorage),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should initialize with AsyncValue.data(null)', () {
    final state = container.read(loginControllerProvider);
    expect(state, const AsyncValue<void>.data(null));
  });

  group('login', () {
    test(
      'should return false and set error state when repository throws DomainError',
      () async {
        when(() => mockRepository.login(tParams)).thenThrow(Exception);

        final controller = container.read(loginControllerProvider.notifier);
        final success = await controller.login(
          enterpriseName: tParams.enterpriseName,
          user: tParams.user,
          password: tParams.password,
        );

        expect(success, false);
        final state = container.read(loginControllerProvider);
        expect(state.hasError, true);
        expect(state.error, Exception);

        verify(() => mockRepository.login(tParams)).called(1);
      },
    );

    test(
      'should succeed, persist enterprise locally, and return true on success',
      () async {
        when(
          () => mockRepository.login(tParams),
        ).thenAnswer((_) async => tEnterpriseEntity);

        when(
          () => mockLocalStorage.put(DatabaseKeys.enterprise.name, any()),
        ).thenAnswer((_) async => Future.value());

        when(
          () => mockLocalStorage.get(DatabaseKeys.allEnterprises.name),
        ).thenAnswer((_) async => []);

        when(
          () => mockLocalStorage.put(DatabaseKeys.allEnterprises.name, any()),
        ).thenAnswer((_) async => Future.value());

        final controller = container.read(loginControllerProvider.notifier);
        final success = await controller.login(
          enterpriseName: tParams.enterpriseName,
          user: tParams.user,
          password: tParams.password,
        );

        expect(success, true);
        final state = container.read(loginControllerProvider);
        expect(state.hasValue, true);

        verify(() => mockRepository.login(tParams)).called(1);
        verify(
          () => mockLocalStorage.put(DatabaseKeys.enterprise.name, any()),
        ).called(greaterThanOrEqualTo(1));
      },
    );
  });
}
