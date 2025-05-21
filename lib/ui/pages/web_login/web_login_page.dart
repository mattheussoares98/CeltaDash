import 'dart:async';

import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class WebLoginPage extends StatefulWidget {
  final WebLoginPresenter presenter;
  const WebLoginPage({super.key, required this.presenter});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.presenter.goToWebCustomersIfStillLogged();
      }
    });
  }

  Future<void> doLogin() async {
    await widget.presenter.doLogin(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(title: Text(R.string.login)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailField(
              emailController: emailController,
              passwordFocusNode: passwordFocusNode,
            ),
            const SizedBox(height: 10),
            PasswordField(
              doLogin: () async {
                await doLogin();
              },
              passwordController: passwordController,
              passwordFocusNode: passwordFocusNode,
            ),
            const SizedBox(height: 10),
            LoginButton(doLogin: () async {
              await doLogin();
            }),
          ],
        ),
      ),
    );
  }
}
