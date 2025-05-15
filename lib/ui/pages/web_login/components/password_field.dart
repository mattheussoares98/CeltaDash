import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class PasswordField extends StatelessWidget {
  final Future<void> Function() doLogin;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  const PasswordField({
    required this.doLogin,
    required this.passwordController,
    required this.passwordFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      focusNode: passwordFocusNode,
      maxLength: 20,
      onFieldSubmitted: (_) async {
        await doLogin();
      },
      decoration: FormFieldDecoration.decoration(
        context: context,
        showCounterText: false,
        hintText: R.string.password,
        labelText: R.string.password,
        errorText: null,
      ),
    );
  }
}
