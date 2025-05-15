import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class LoginButton extends StatelessWidget {
  final Future<void> Function() doLogin;
  const LoginButton({
    required this.doLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await doLogin();
      },
      child: Text(R.string.login),
    );
  }
}
