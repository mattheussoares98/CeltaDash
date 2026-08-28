// test/core/data/repository/theme_repository_impl_test.dart
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeLocalDatasource extends Mock implements IThemeLocalDatasource {}

void main() {
  late MockThemeLocalDatasource mockDatasource;
  late ThemeRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(AppThemeMode.light);
  });

  setUp(() {
    mockDatasource = MockThemeLocalDatasource();
    repository = ThemeRepositoryImpl(mockDatasource);
  });

  group('getThemeMode', () {
    test('should forward getThemeMode call to datasource', () async {
      when(() => mockDatasource.getThemeMode())
          .thenAnswer((_) async => AppThemeMode.dark);

      final result = await repository.getThemeMode();

      expect(result, AppThemeMode.dark);
      verify(() => mockDatasource.getThemeMode()).called(1);
    });
  });

  group('setThemeMode', () {
    test('should forward saveThemeMode call to datasource', () async {
      when(() => mockDatasource.saveThemeMode(any()))
          .thenAnswer((_) async {});

      await repository.setThemeMode(AppThemeMode.dark);

      verify(() => mockDatasource.saveThemeMode(AppThemeMode.dark)).called(1);
    });
  });
}
