import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import 'components.dart';

class DefaultExpansionTile extends StatelessWidget {
  final String title;
  final List<CheckBoxItem> children;
  const DefaultExpansionTile({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(50);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: ContainerDecoration.defaultDecoration,
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(4),
        backgroundColor: backgroundColor,
        collapsedBackgroundColor: backgroundColor,
        title: Text(title),
        children: children,
      ),
    );
  }
}
