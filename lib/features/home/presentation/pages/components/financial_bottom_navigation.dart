// lib/features/home/presentation/pages/components/financial_bottom_navigation.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinancialBottomNavigation extends StatelessWidget {
  const FinancialBottomNavigation({
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
            key: ValueKey('financial_navigation_resume'),
            materialIcon: Icons.pie_chart,
            cupertinoIcon: CupertinoIcons.chart_pie,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Movimentação'.hardcoded,
          platformIcon: const PlatformIcon(
            key: ValueKey('financial_navigation_periods'),
            materialIcon: Icons.calendar_month,
            cupertinoIcon: CupertinoIcons.calendar,
          ),
        ),
      ],
    );
  }
}
