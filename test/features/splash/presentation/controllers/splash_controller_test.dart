import 'package:celta_dash/features/splash/domain/domain.dart';
import 'package:celta_dash/features/splash/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/splash/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class MockSplashRepository extends Mock implements ISplashRepository {}

void main() {
  late MockSplashRepository mockSplashRepository;

  setUp(() {
    mockSplashRepository = MockSplashRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        splashRepositoryProvider.overrideWithValue(mockSplashRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('SplashController', () {
    test('should return updateRequired when update is required', () async {
      when(
        () => mockSplashRepository.isUpdateRequired(),
      ).thenAnswer((_) async => true);

      final container = createContainer();
      final destination = await container.read(splashControllerProvider.future);

      expect(destination, SplashDestination.updateRequired);
      verifyNever(() => mockSplashRepository.getSavedEnterprise());
    });

    test(
      'should return home when valid enterprise with user is saved',
      () async {
        when(
          () => mockSplashRepository.isUpdateRequired(),
        ).thenAnswer((_) async => false);
        when(
          () => mockSplashRepository.getSavedEnterprise(),
        ).thenAnswer((_) async => EntityFactory.makeFirebaseEnterpriseEntity());

        final container = createContainer();
        final destination = await container.read(
          splashControllerProvider.future,
        );

        expect(destination, SplashDestination.home);
      },
    );

    test('should return login when no saved enterprise exists', () async {
      when(
        () => mockSplashRepository.isUpdateRequired(),
      ).thenAnswer((_) async => false);
      when(
        () => mockSplashRepository.getSavedEnterprise(),
      ).thenAnswer((_) async => null);

      final container = createContainer();
      final destination = await container.read(splashControllerProvider.future);

      expect(destination, SplashDestination.login);
    });

    test('should return login when enterprise has incomplete bsUser', () async {
      when(
        () => mockSplashRepository.isUpdateRequired(),
      ).thenAnswer((_) async => false);
      when(() => mockSplashRepository.getSavedEnterprise()).thenAnswer(
        (_) async => EntityFactory.makeFirebaseEnterpriseEntity().copyWith(
          bsUser: EntityFactory.makeBsUserEntity().copyWith(
            annulAccessKey: true,
            annulCrossIdentity_Usuario: true,
          ),
          annulFirebaseSubEnterprises: true,
        ),
      );

      final container = createContainer();
      final destination = await container.read(splashControllerProvider.future);

      expect(destination, SplashDestination.login);
    });

    test('should return login when enterprise has no user', () async {
      when(
        () => mockSplashRepository.isUpdateRequired(),
      ).thenAnswer((_) async => false);
      when(() => mockSplashRepository.getSavedEnterprise()).thenAnswer(
        (_) async => EntityFactory.makeFirebaseEnterpriseEntity().copyWith(
          annulBsUser: true,
        ),
      );

      final container = createContainer();
      final destination = await container.read(splashControllerProvider.future);

      expect(destination, SplashDestination.login);
    });
  });
}
