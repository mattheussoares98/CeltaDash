import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController bsPasswordController;
  final FocusNode bsPasswordFocusNode;
  final void Function() onSubmit;

  const PasswordField({
    super.key,
    required this.bsPasswordController,
    required this.bsPasswordFocusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: bsPasswordController,
        focusNode: bsPasswordFocusNode,
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: R.string.bsPassword,
        ),
        onFieldSubmitted: (_) => onSubmit(),
      ),
    );
  }
}
