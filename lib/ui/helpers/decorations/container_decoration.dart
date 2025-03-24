import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class ContainerDecoration {
  ContainerDecoration._();

  static BoxDecoration get decoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Theme.of(NavigatorKey.key.currentState!.context).primaryColorLight.withAlpha(60),
    ),
    boxShadow: [
      BoxShadow(
        color: Theme.of(
          NavigatorKey.key.currentState!.context,
        ).primaryColorLight.withAlpha(50),
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
      BoxShadow(
        color: Theme.of(
          NavigatorKey.key.currentState!.context,
        ).primaryColorLight.withAlpha(50),
        offset: Offset(-2, -2),
        blurRadius: 4,
      ),
    ],
  );
}
