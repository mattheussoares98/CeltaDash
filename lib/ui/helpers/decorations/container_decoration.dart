import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class ContainerDecoration {
  ContainerDecoration._();

  static BoxDecoration get decoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Theme.of(
          NavigatorKey.key.currentState!.context,
        ).primaryColorLight.withAlpha(30),
        offset: Offset(2, 2),
        blurRadius: 1,
      ),
      BoxShadow(
        color: Theme.of(
          NavigatorKey.key.currentState!.context,
        ).primaryColorLight.withAlpha(30),
        offset: Offset(-2, -2),
        blurRadius: 1,
      ),
    ],
  );
}
