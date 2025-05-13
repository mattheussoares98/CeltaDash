import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../helpers/helpers.dart';
import '../login.dart';

class EnterpriseField extends StatelessWidget {
  final TextEditingController enterpriseController;
  final FocusNode enterpriseFocusNode;
  final FocusNode emailFocusNode;

  const EnterpriseField({
    super.key,
    required this.enterpriseController,
    required this.enterpriseFocusNode,
    required this.emailFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    LoginPresenter loginPresenter = Get.find();

    return TextFormField(
      controller: enterpriseController,
      focusNode: enterpriseFocusNode,
      onChanged: (_) {
        loginPresenter.onChangedEnterpriseName();
      },
      onFieldSubmitted: (_) {
        Future.delayed(Duration.zero, () {
          emailFocusNode.requestFocus();
        });
      },
      validator: (value) {
        return ValidationComposite([
          RequiredFieldValidation(),
          MinLengthValidation(size: 2),
        ]).validate(value)?.description;
      },
      decoration: FormFieldDecoration.decoration(
        context: context,
        hintText: R.string.enterprise,
        labelText: R.string.enterprise,
        prefixIcon: Icon(Icons.business, color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}
