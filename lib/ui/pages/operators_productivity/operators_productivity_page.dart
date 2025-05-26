import 'package:flutter/material.dart';

import '../pages.dart';

class OperatorsProductivityPage extends StatelessWidget {
  final OperatorsProductivityPresenter presenter;
  const OperatorsProductivityPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Operators Productivity")),
      body: Center(child: Text("Operators Productivity")),
    );
  }
}
