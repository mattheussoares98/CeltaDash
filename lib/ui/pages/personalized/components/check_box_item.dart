import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CheckBoxItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool value;
  const CheckBoxItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      child: CheckboxListTile(
        value: value,
        onChanged: (_) => onTap(),
        dense: true,
        title: Text(title),
      ),
    );
  }
}
