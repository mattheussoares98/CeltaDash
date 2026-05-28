import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultTabBar extends StatelessWidget {
  final List<DefaultTab> tabs;
  const DefaultTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Theme.of(context).disabledColor,
      dividerColor: Colors.transparent,
      labelPadding: const EdgeInsets.all(8),
      indicatorSize: TabBarIndicatorSize.label,
      padding: const EdgeInsets.all(4),
      splashBorderRadius: BorderRadius.circular(20),
      dividerHeight: 0,
      indicatorPadding: const EdgeInsets.all(3),
      indicatorWeight: 0.1,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
      tabs: tabs,
    );
  }
}

class DefaultTab extends StatelessWidget {
  final String title;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  const DefaultTab({
    super.key,
    required this.title,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          size: 20,
          !kIsWeb && Platform.isIOS ? cupertinoIcon : materialIcon,
        ),
        Text(title),
      ],
    );
  }
}
