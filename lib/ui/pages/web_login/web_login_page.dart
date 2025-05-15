import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

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
        WebLoginPresenter webLoginPresenter = Get.find();

        await webLoginPresenter.goToWebCustomersIfStillLogged();
      }
    });
  }

  Future<void> doLogin(WebLoginPresenter webLoginPresenter) async {
    await webLoginPresenter.doLogin(
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
    WebLoginPresenter webLoginPresenter = Get.find();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, webLoginPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, webLoginPresenter.mainErrorStream);

    return Scaffold(
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
                await doLogin(webLoginPresenter);
              },
              passwordController: passwordController,
              passwordFocusNode: passwordFocusNode,
            ),
            const SizedBox(height: 10),
            LoginButton(doLogin: () async {
              await doLogin(webLoginPresenter);
            }),
          ],
        ),
      ),
    );
  }
}
