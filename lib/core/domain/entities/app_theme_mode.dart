// lib/core/domain/entities/app_theme_mode.dart
enum AppThemeMode {
  light,
  dark,
  system;

  bool get isDark => this == AppThemeMode.dark;
  bool get isLight => this == AppThemeMode.light;
}
