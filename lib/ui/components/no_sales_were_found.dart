import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class NoSalesWereFound extends StatelessWidget {
  const NoSalesWereFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        R.string.msgNoSalesWereFound,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
