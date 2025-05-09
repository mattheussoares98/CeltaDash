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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton.icon(
        onPressed: onTap,
        label: FittedBox(child: Text(title)),
        icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}
