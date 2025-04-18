import 'package:flutter/material.dart';

import './splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkPageToGo();

    return Scaffold(
      body: Center(
        child: Image.asset(
          key: const Key("loading"),
          'lib/ui/assets/images/wait.gif',
        ),
      ),
    );
  }
}
