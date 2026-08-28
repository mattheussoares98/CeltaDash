// lib/core/data/datasource/i_theme_local_datasource.dart
import 'package:celta_dash/core/domain/domain.dart';

abstract class IThemeLocalDatasource {
  Future<AppThemeMode> getThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);
}
