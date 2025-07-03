import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class UserNameField extends StatelessWidget {
  final TextEditingController bsUserNameController;
  final FocusNode bsUserNameFocusNode;
  final FocusNode bsPasswordFocusNode;
  const UserNameField({
    super.key,
    required this.bsUserNameController,
    required this.bsUserNameFocusNode,
    required this.bsPasswordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: bsUserNameController,
        focusNode: bsUserNameFocusNode,
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: R.string.bsUserName,
        ),
        onFieldSubmitted: (_) {
          bsPasswordFocusNode.requestFocus();
        },
      ),
    );
  }
}
