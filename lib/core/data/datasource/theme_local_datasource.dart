// lib/core/data/datasource/theme_local_datasource.dart
import 'package:celta_dash/core/data/datasource/datasource.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';

class ThemeLocalDatasource implements IThemeLocalDatasource {
  const ThemeLocalDatasource(this._storage);

  final IAppStorage _storage;

  @override
  Future<AppThemeMode> getThemeMode() async {
    final savedMode = await _storage.get(DatabaseKeys.themeMode.name);
    if (savedMode is String) {
      return AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => AppThemeMode.light,
      );
    }
    return AppThemeMode.light;
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) =>
      _storage.put(DatabaseKeys.themeMode.name, mode.name);
}
