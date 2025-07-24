import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../components.dart';

class DefaultExpansionTile extends StatelessWidget {
  final String title;
  final List<CheckBoxItem> children;
  final Widget? itemAboveChildren;
  final Widget? itemBelowChildren;
  const DefaultExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.itemAboveChildren,
    this.itemBelowChildren,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: ContainerDecoration.defaultDecoration,
      child: ExpansionTile(
        initiallyExpanded: false,
        dense: true,
        childrenPadding: const EdgeInsets.all(4),
        backgroundColor: backgroundColor,
        collapsedBackgroundColor: backgroundColor,
        title: Text(title),
        children: [
          if (itemAboveChildren != null) itemAboveChildren!,
          ...children,
          if (itemBelowChildren != null) itemBelowChildren!,
        ],
      ),
    );
  }
}
