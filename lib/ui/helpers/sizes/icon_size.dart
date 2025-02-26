import 'package:flutter/material.dart';

import 'has_min_width.dart';

double getIconSize(BuildContext context) {
  return hasMinWidth(context) ? 35 : 30;
}
