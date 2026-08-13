import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode passwordFocusNode;
  const EmailField({
    required this.emailController,
    required this.passwordFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      maxLength: 30,
      decoration: FormFieldDecoration.decoration(
        context: context,
        hintText: R.string.email,
        labelText: R.string.email,
      ),
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
    );
  }
}
