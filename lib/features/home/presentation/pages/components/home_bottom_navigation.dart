import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({super.key, required this.currentLocation});

  final String currentLocation;

  static const _routeNames = [
    Routes.homeResume,
    Routes.homeSales,
    Routes.homeProducts,
    Routes.homePersonalized,
    Routes.homeMore,
  ];

  int get _currentIndex {
    final index = _routeNames.indexWhere(
      // Example: route.name is "homeProducts". substring(4) removes the first
      // four characters ("home"), leaving "Products". toLowerCase() converts
      // it to "products", then endsWith checks for "/products" in the URL.
      (route) =>
          currentLocation.endsWith('/${route.name.substring(4).toLowerCase()}'),
    );
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => context.goNamed(_routeNames[index].name),
      items: [
        BaseBottomNavigationBarItem(
          label: 'Resume'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_resume'),
            materialIcon: Icons.pie_chart,
            cupertinoIcon: CupertinoIcons.chart_pie,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Sales'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_sales'),
            materialIcon: Icons.monetization_on,
            cupertinoIcon: CupertinoIcons.money_dollar,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Products'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_products'),
            materialIcon: Icons.shopping_cart_rounded,
            cupertinoIcon: CupertinoIcons.cart,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Personalized'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('home_navigation_personalized'),
            materialIcon: Icons.assignment_ind,
            cupertinoIcon: CupertinoIcons.doc_person,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'More'.hardcoded,
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
