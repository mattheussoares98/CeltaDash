import 'package:flutter/material.dart';

class DefaultNavigateButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  const DefaultNavigateButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: Text(title));
  }
}
