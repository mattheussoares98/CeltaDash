import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedPageIndex;
  final void Function(int)? updateSelectedPageIndex;
  const BottomNavigation({
    super.key,
    required this.selectedPageIndex,
    required this.updateSelectedPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: updateSelectedPageIndex,
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
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: R.string.departments,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_module),
          label: R.string.sections,
        ),
      ],
    );
  }
}
