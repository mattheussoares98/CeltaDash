import 'package:flutter/material.dart';

import 'screen_size.dart';

double getIconSize(BuildContext context) {
  return ScreenSize.hasMinWidth ? 35 : 30;
}
