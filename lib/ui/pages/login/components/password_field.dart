import 'package:flutter/material.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
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
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: Icon(Icons.remove_red_eye),
        ),
      ),
    );
  }
}
