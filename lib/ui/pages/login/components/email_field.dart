import 'package:flutter/material.dart';

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
        return null; //TODO change how validate
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
