import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebLoginEmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const WebLoginEmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) => BaseTextFormField(
    controller: controller,
    focusNode: focusNode,
    labelText: 'E-mail'.hardcoded,
    hintText: 'E-mail'.hardcoded,
    keyboardType: TextInputType.emailAddress,
    prefixIcon: const PlatformIcon(
      cupertinoIcon: CupertinoIcons.mail_solid,
      materialIcon: Icons.email,
    ),
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (_) => nextFocusNode.requestFocus(),
    validator: FormValidators.compose([NonEmptyValidator(), EmailValidator()]),
  );
}
