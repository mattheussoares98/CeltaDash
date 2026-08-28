// lib/core/domain/repository/i_theme_repository.dart
import 'package:celta_dash/core/domain/domain.dart';

abstract class IThemeRepository {
  Future<AppThemeMode> getThemeMode();

  Future<void> setThemeMode(AppThemeMode mode);
}
