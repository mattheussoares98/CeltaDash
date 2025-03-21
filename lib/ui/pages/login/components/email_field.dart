import 'package:flutter/material.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../helpers/helpers.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const EmailField({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      focusNode: emailFocusNode,
      onFieldSubmitted: (_) {
        Future.delayed(Duration.zero, () {
          passwordFocusNode.requestFocus();
        });
      },
      validator: (value) {
        return ValidationComposite([
          RequiredFieldValidation(),
          EmailFieldValidation(),
        ]).validate(value)?.description;
      },
      decoration: FormFieldDecoration.decoration(
        context: context,
        hintText: R.string.email,
        labelText: R.string.email,
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }
}
