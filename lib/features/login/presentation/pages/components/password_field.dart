// lib/features/login/presentation/pages/components/password_field.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordField extends HookWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final showPassword = useState(false);

    return BaseTextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !showPassword.value,
      labelText: 'Senha'.hardcoded,
      hintText: 'Senha'.hardcoded,
      autofillHints: const [AutofillHints.password],
      prefixIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.lock_fill,
        materialIcon: Icons.lock,
      ),
      suffixIcon: IconButton(
        icon: PlatformIcon(
          cupertinoIcon: showPassword.value
              ? CupertinoIcons.eye_slash_fill
              : CupertinoIcons.eye_fill,
          materialIcon: showPassword.value
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: () => showPassword.value = !showPassword.value,
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onSubmitted(),
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(3),
      ]),
    );
  }
}
