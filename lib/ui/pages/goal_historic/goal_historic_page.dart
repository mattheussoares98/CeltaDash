import 'package:flutter/material.dart';

import '../pages.dart';

class GoalHistoricPage extends StatelessWidget {
  final GoalHistoricPresenter presenter;
  const GoalHistoricPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goal History")),
      body: const Center(child: Text("Goal History")),
    );
  }
}
