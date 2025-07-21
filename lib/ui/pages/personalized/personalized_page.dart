import 'package:flutter/material.dart';

import 'personalized.dart';

class PersonalizedPage extends StatelessWidget {
  final PersonalizedPresenter presenter;
  const PersonalizedPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personalized")),
    );
  }
}
