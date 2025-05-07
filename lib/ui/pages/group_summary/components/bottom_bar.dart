import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class BottomBar extends StatelessWidget {
  final void Function(int index) onChangePage;
  final int currentIndex;
  const BottomBar({
    super.key,
    required this.onChangePage,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onChangePage,
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
          icon: Icon(Icons.bar_chart_rounded),
          label: R.string.details,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: R.string.resume,
        ),
      ],
    );
  }
}
