import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class ScreenSize {
  static bool get hasMinWidth =>
      MediaQuery.of(NavigatorKey.key.currentState!.context).size.width > 900;
}
