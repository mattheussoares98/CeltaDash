import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  const DefaultButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(onPressed: onTap, child: Text(title)),
    );
  }
}
