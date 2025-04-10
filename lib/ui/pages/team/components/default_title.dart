import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class DefaultTitle extends StatelessWidget {
  final String title;
  const DefaultTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColorDark,
        fontSize: StringSize.size * 1.3,
      ),
    );
  }
}
