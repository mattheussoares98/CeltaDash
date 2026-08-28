// lib/core/data/repository/theme_repository_impl.dart
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';

class ThemeRepositoryImpl implements IThemeRepository {
  const ThemeRepositoryImpl(this._datasource);

  final IThemeLocalDatasource _datasource;

  @override
  Future<AppThemeMode> getThemeMode() => _datasource.getThemeMode();

  @override
  Future<void> setThemeMode(AppThemeMode mode) =>
      _datasource.saveThemeMode(mode);
}
