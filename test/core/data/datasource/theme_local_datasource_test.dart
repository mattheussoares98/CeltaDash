// test/core/data/datasource/theme_local_datasource_test.dart
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppStorage extends Mock implements IAppStorage {}

void main() {
  late MockAppStorage mockStorage;
  late ThemeLocalDatasource datasource;

  setUp(() {
    mockStorage = MockAppStorage();
    datasource = ThemeLocalDatasource(mockStorage);
  });

  group('getThemeMode', () {
    test('should return AppThemeMode.light when no theme is saved', () async {
      when(() => mockStorage.get(DatabaseKeys.themeMode.name))
          .thenAnswer((_) async => null);

      final result = await datasource.getThemeMode();

      expect(result, AppThemeMode.light);
      verify(() => mockStorage.get(DatabaseKeys.themeMode.name)).called(1);
    });

    test('should return saved AppThemeMode when valid string is stored', () async {
      when(() => mockStorage.get(DatabaseKeys.themeMode.name))
          .thenAnswer((_) async => 'dark');

      final result = await datasource.getThemeMode();

      expect(result, AppThemeMode.dark);
      verify(() => mockStorage.get(DatabaseKeys.themeMode.name)).called(1);
    });

    test('should return AppThemeMode.light when stored string is invalid', () async {
      when(() => mockStorage.get(DatabaseKeys.themeMode.name))
          .thenAnswer((_) async => 'invalid_theme');

      final result = await datasource.getThemeMode();

      expect(result, AppThemeMode.light);
      verify(() => mockStorage.get(DatabaseKeys.themeMode.name)).called(1);
    });
  });

  group('saveThemeMode', () {
    test('should save theme mode name to storage', () async {
      when(() => mockStorage.put(DatabaseKeys.themeMode.name, any()))
          .thenAnswer((_) async {});

      await datasource.saveThemeMode(AppThemeMode.dark);

      verify(() => mockStorage.put(DatabaseKeys.themeMode.name, 'dark')).called(1);
    });
  });
}
