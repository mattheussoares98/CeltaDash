import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class ScreenSize {
  ScreenSize._() {
    _hasMinWidth =
        MediaQuery.of(NavigatorKey.key.currentState!.context).size.width > 900;
  }

  static bool _hasMinWidth = false;
  static bool get hasMinWidth => _hasMinWidth;
}
