import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

class StringSize {
  StringSize._();

  static double _size = 15;
  static double get size => _size;
  static void updateStringSize(BuildContext context) {
    if (hasMinWidth(context)) {
      _size = 22;
    } else {
      _size = 15;
    }
  }
}
