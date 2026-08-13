import 'package:flutter/material.dart';

import '../../../main/utils/utils.dart';

class ContainerDecoration {
  ContainerDecoration._();

  static final context = NavigatorKey.key.currentState!.context;
  static final theme = Theme.of(context);

  static BoxDecoration get defaultDecoration => BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.disabledColor.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColorLight.withAlpha(50),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: theme.primaryColorLight.withAlpha(50),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      );

  static BoxDecoration get disabled => BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.error.withAlpha(50),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: theme.colorScheme.error.withAlpha(50),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      );
  static BoxDecoration get enabled => BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
        boxShadow: const [
          BoxShadow(
            color: Colors.green,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      );
}
