// lib/core/presentation/controllers/theme_mode_controller.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

extension AppThemeModeX on AppThemeMode {
  ThemeMode toFlutterThemeMode() => switch (this) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.system => ThemeMode.system,
  };
}

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  FutureOr<AppThemeMode> build() async {
    final repository = ref.watch(themeRepositoryProvider);
    return repository.getThemeMode();
  }

  Future<void> toggleTheme() async {
    final current = state.value ?? AppThemeMode.light;
    final nextMode = current == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;

    state = AsyncData(nextMode);
    await ref.read(themeRepositoryProvider).setThemeMode(nextMode);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = AsyncData(mode);
    await ref.read(themeRepositoryProvider).setThemeMode(mode);
  }
}
