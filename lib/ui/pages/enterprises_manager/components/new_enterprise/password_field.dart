import 'package:flutter/material.dart';

import '../../../../../main/composites/composites.dart';
import '../../../../../presentation/protocols/protocols.dart';
import '../../../../../validation/validators/validators.dart';
import '../../../../helpers/helpers.dart';

class PasswordField extends StatefulWidget {
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
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: widget.bsPasswordController,
        focusNode: widget.bsPasswordFocusNode,
        obscureText: !showPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => ValidationComposite([
          const RequiredFieldValidation(),
        ]).validate(value)?.description,
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: R.string.bsPassword,
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
        onFieldSubmitted: (_) {
          widget.onSubmit();
        },
      ),
    );
  }
}
