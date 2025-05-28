import 'dart:ui';

import 'package:flutter/widgets.dart';

class IsDarkTheme {
  IsDarkTheme._();

  static bool isDark(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;
}
