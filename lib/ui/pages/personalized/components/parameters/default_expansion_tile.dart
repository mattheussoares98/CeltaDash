import 'package:flutter/material.dart';

class DefaultExpansionTile extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final ExpansibleController controller;
  const DefaultExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.disabledColor.withAlpha(70);

    return ExpansionTile(
      controller: controller,
      initiallyExpanded: false,
      dense: true,
      childrenPadding: const EdgeInsets.all(4),
      tilePadding: const EdgeInsets.all(4),
      backgroundColor: color,
      collapsedBackgroundColor: color,
      title: title,
      children: children,
    );
  }
}
