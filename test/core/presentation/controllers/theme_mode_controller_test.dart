// test/core/presentation/controllers/theme_mode_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/presentation/presentation.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeRepository extends Mock implements IThemeRepository {}

void main() {
  late MockThemeRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(AppThemeMode.light);
  });

  setUp(() {
    mockRepository = MockThemeRepository();
    container = ProviderContainer(
      overrides: [themeRepositoryProvider.overrideWithValue(mockRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ThemeModeController.build', () {
    test('should initialize with value from repository', () async {
      when(
        () => mockRepository.getThemeMode(),
      ).thenAnswer((_) async => AppThemeMode.dark);

      final state = await container.read(themeModeControllerProvider.future);

      expect(state, AppThemeMode.dark);
      verify(() => mockRepository.getThemeMode()).called(1);
    });
  });

  group('ThemeModeController.toggleTheme', () {
    test('should toggle from light to dark and persist', () async {
      when(
        () => mockRepository.getThemeMode(),
      ).thenAnswer((_) async => AppThemeMode.light);
      when(() => mockRepository.setThemeMode(any())).thenAnswer((_) async {});

      await container.read(themeModeControllerProvider.future);

      await container.read(themeModeControllerProvider.notifier).toggleTheme();

      expect(
        container.read(themeModeControllerProvider).value,
        AppThemeMode.dark,
      );
      verify(() => mockRepository.setThemeMode(AppThemeMode.dark)).called(1);
    });

    test('should toggle from dark to light and persist', () async {
      when(
        () => mockRepository.getThemeMode(),
      ).thenAnswer((_) async => AppThemeMode.dark);
      when(() => mockRepository.setThemeMode(any())).thenAnswer((_) async {});

      await container.read(themeModeControllerProvider.future);

      await container.read(themeModeControllerProvider.notifier).toggleTheme();

      expect(
        container.read(themeModeControllerProvider).value,
        AppThemeMode.light,
      );
      verify(() => mockRepository.setThemeMode(AppThemeMode.light)).called(1);
    });
  });

  group('ThemeModeController.setThemeMode', () {
    test('should update state and persist specific theme mode', () async {
      when(
        () => mockRepository.getThemeMode(),
      ).thenAnswer((_) async => AppThemeMode.light);
      when(() => mockRepository.setThemeMode(any())).thenAnswer((_) async {});

      await container.read(themeModeControllerProvider.future);

      await container
          .read(themeModeControllerProvider.notifier)
          .setThemeMode(AppThemeMode.dark);

      expect(
        container.read(themeModeControllerProvider).value,
        AppThemeMode.dark,
      );
      verify(() => mockRepository.setThemeMode(AppThemeMode.dark)).called(1);
    });
  });
}
