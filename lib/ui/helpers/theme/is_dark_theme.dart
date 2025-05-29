import 'package:flutter/widgets.dart';

class IsDarkTheme {
  IsDarkTheme._();

  static bool _isDark = false;
  static bool get isDark => _isDark;

  static void updateIsDark(BuildContext context) {
    _isDark = false;
    // _isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
