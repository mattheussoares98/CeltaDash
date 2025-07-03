import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class ContainerDecoration {
  ContainerDecoration._();

  static final context = NavigatorKey.key.currentState!.context;

  static BoxDecoration get defaultDecoration => BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColorLight.withAlpha(60),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).primaryColorLight.withAlpha(50),
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Theme.of(
              context,
            ).primaryColorLight.withAlpha(50),
            offset: Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      );

  static BoxDecoration get disabled => BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error,
          strokeAlign: 0.4,
          width: 0.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.error,
            offset: Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      );
  static BoxDecoration get enabled => BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      );
}
