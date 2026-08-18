import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
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
            key: ValueKey('home_navigation_resume'),
            materialIcon: Icons.pie_chart,
            cupertinoIcon: CupertinoIcons.chart_pie,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Vendas'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_sales'),
            materialIcon: Icons.monetization_on,
            cupertinoIcon: CupertinoIcons.money_dollar,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Produtos'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_products'),
            materialIcon: Icons.shopping_cart_rounded,
            cupertinoIcon: CupertinoIcons.cart,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Personalizado'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_personalized'),
            materialIcon: Icons.assignment_ind,
            cupertinoIcon: CupertinoIcons.doc_person,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Mais'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_more'),
            materialIcon: Icons.grid_view_rounded,
            cupertinoIcon: CupertinoIcons.square_grid_2x2_fill,
          ),
        ),
      ],
    );
  }
}
