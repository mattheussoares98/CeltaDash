import 'package:flutter/material.dart';

class PersonalizedTableCell extends StatelessWidget {
  final String name;
  const PersonalizedTableCell({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
