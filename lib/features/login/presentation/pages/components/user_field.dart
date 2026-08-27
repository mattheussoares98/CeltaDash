// lib/features/login/presentation/pages/components/user_field.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const UserField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'Usuário do BS'.hardcoded,
      hintText: 'Usuário do BS'.hardcoded,
      prefixIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.person_fill,
        materialIcon: Icons.person,
      ),
      autofillHints: const [AutofillHints.username],
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => nextFocusNode.requestFocus(),
      validator: FormValidators.compose([NonEmptyValidator()]),
    );
  }
}
