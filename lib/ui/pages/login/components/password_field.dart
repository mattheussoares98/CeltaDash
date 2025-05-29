import 'package:flutter/material.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../helpers/helpers.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final void Function() login;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.login,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: widget.passwordController,
        obscureText: !showPassword,
        focusNode: widget.passwordFocusNode,
        onFieldSubmitted: (_) => widget.login(),
        validator: (value) {
          return ValidationComposite([
            RequiredFieldValidation(),
            MinLengthValidation(size: 3),
          ]).validate(value)?.description;
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          hintText: R.string.password,
          labelText: R.string.password,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
