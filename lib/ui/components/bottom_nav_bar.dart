import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final void Function(int index) onTap;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColorDark,
        inactiveColor: CupertinoColors.inactiveGray,
        backgroundColor: CupertinoColors.systemGrey6,
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: item.cupertinoIcon,
                label: item.label,
              ),
            )
            .toList(),
      );
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 10,
      selectedFontSize: 12,
      selectedIconTheme: IconThemeData(
        size: 30,
        color: Theme.of(context).primaryColorDark,
      ),
      unselectedIconTheme: IconThemeData(
        size: 20,
        color: Theme.of(context).primaryColorLight,
      ),
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.materialIcon,
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}

class BottomNavItem {
  final Icon materialIcon;
  final Icon cupertinoIcon;
  final String label;

  const BottomNavItem({
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.label,
  });
}
