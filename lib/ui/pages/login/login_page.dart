import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> login(LoginPresenter loginPresenter) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await loginPresenter.login(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    LoginPresenter loginPresenter = Provider.of(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmailField(
                emailController: emailController,
                emailFocusNode: emailFocusNode,
                passwordFocusNode: passwordFocusNode,
              ),
              PasswordField(
                passwordController: passwordController,
                login: () async {
                  await login(loginPresenter);
                },
                passwordFocusNode: passwordFocusNode,
              ),
              ElevatedButton(
                onPressed: () async {
                  await login(loginPresenter);
                },
                child: Text(R.string.enter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
