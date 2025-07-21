import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CheckBoxItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CheckBoxItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.defaultDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CheckboxListTile(
        value: false, //TODO add parameter value
        onChanged: (_) => onTap(),
        dense: true,
        title: Text(title),
      ),
    );
  }
}
