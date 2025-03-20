import 'package:flutter/material.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        return ValidationComposite([
          RequiredFieldValidation(),
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
