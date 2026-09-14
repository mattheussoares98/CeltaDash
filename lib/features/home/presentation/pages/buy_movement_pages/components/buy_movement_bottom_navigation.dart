import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuyMovementBottomNavigation extends StatelessWidget {
  const BuyMovementBottomNavigation({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BaseBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BaseBottomNavigationBarItem(
          label: 'Resumo'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('buy_movement_navigation_resume'),
            materialIcon: Icons.pie_chart,
            cupertinoIcon: CupertinoIcons.chart_pie,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Períodos'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('buy_movement_navigation_periods'),
            materialIcon: Icons.calendar_month,
            cupertinoIcon: CupertinoIcons.calendar,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Produtos'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('buy_movement_navigation_products'),
            materialIcon: Icons.shopping_cart_rounded,
            cupertinoIcon: CupertinoIcons.cart,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Departamentos'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('buy_movement_navigation_departments'),
            materialIcon: Icons.category,
            cupertinoIcon: CupertinoIcons.square_grid_2x2,
          ),
        ),
      ],
    );
  }
}
