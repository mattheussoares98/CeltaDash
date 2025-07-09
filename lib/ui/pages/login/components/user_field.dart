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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: emailController,
        focusNode: emailFocusNode,
        onFieldSubmitted: (_) {
          Future.delayed(Duration.zero, () {
            passwordFocusNode.requestFocus();
          });
        },
        validator: (value) {
          return ValidationComposite([
            const RequiredFieldValidation(),
          ]).validate(value)?.description;
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          hintText: R.string.user,
          labelText: R.string.user,
          prefixIcon: const Icon(
            Icons.person,
          ),
        ),
      ),
    );
  }
}
