import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with LoadingManager, UIErrorManager {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final enterpriseController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final enterpriseFocusNode = FocusNode();
  StreamSubscription? errorSubscription;
  StreamSubscription? loadingSubscription;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    enterpriseController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    enterpriseFocusNode.dispose();
    errorSubscription?.cancel();
    loadingSubscription?.cancel();
  }

  Future<void> login(LoginPresenter loginPresenter) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await loginPresenter.login(
      user: emailController.text,
      password: passwordController.text,
      showBsErrorMessage: (error) {
        snackBarMessage(context, error, backgroundColor: Colors.red);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    LoginPresenter loginPresenter = Provider.of(context, listen: false);
    errorSubscription?.cancel();
    loadingSubscription?.cancel();

    errorSubscription = handleMainError(
      context,
      loginPresenter.mainErrorStream,
    );
    loadingSubscription = handleLoading(
      context,
      loginPresenter.isLoadingStream,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EnterpriseField(
                enterpriseController: enterpriseController,
                enterpriseFocusNode: enterpriseFocusNode,
                emailFocusNode: emailFocusNode,
              ),
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
