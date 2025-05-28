import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final void Function(int index) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        height: 50,
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
  final String? label;

  const BottomNavItem({
    required this.materialIcon,
    required this.cupertinoIcon,
    this.label,
  });
}
