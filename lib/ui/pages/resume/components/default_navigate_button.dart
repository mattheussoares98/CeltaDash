import 'package:flutter/material.dart';

class DefaultNavigateButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Icon? icon;
  const DefaultNavigateButton({
    super.key,
    this.icon,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      label: Text(title),
      icon: icon,
      iconAlignment: IconAlignment.end,
    );
  }
}
