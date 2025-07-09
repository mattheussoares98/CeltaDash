import 'package:flutter/material.dart';

import '../../../../../main/composites/composites.dart';
import '../../../../../presentation/protocols/protocols.dart';
import '../../../../../validation/validators/validators.dart';
import '../../../../helpers/helpers.dart';

class EnterpriseNameField extends StatelessWidget {
  final TextEditingController enterpriseNameController;
  final FocusNode enterpriseNameFocusNode;
  final FocusNode bsUserNameFocusNode;
  const EnterpriseNameField({
    super.key,
    required this.enterpriseNameController,
    required this.enterpriseNameFocusNode,
    required this.bsUserNameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: enterpriseNameController,
      focusNode: enterpriseNameFocusNode,
      decoration: FormFieldDecoration.decoration(
        context: context,
        labelText: R.string.enterpriseName,
      ),
      onFieldSubmitted: (_) {
        bsUserNameFocusNode.requestFocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => ValidationComposite([
        const RequiredFieldValidation(),
      ]).validate(value)?.description,
    );
  }
}
