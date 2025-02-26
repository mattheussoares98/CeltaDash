import 'package:flutter/material.dart';

import 'login.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("login")));
  }
}
