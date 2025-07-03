import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import 'new_enterprise.dart';

class AddNewEnterprise extends StatelessWidget {
  final TextEditingController enterpriseNameController;
  final TextEditingController bsUserNameController;
  final TextEditingController bsPasswordController;

  final FocusNode enterpriseNameFocusNode;
  final FocusNode bsUserNameFocusNode;
  final FocusNode bsPasswordFocusNode;
  const AddNewEnterprise({
    super.key,
    required this.enterpriseNameController,
    required this.bsUserNameController,
    required this.bsPasswordController,
    required this.enterpriseNameFocusNode,
    required this.bsUserNameFocusNode,
    required this.bsPasswordFocusNode,
  });

  Future<void> onSubmit(
    EnterprisesManagerPresenter enterprisesManagerPresenter,
  ) async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    bool added = await enterprisesManagerPresenter.addNewEnterprise(
      enterpriseName: enterpriseNameController.text,
      userName: bsUserNameController.text,
      userPassword: bsPasswordController.text,
    );

    if (added) {
      enterpriseNameController.clear();
      bsUserNameController.clear();
      bsPasswordController.clear();
    }
  }

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();

    return Form(
      key: _formKey,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(4),
          title: Text(
            R.string.addNewEnterprise,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          onExpansionChanged: (value) {
            if (value) {
              enterpriseNameFocusNode.requestFocus();
            }
          },
          children: [
            EnterpriseNameField(
              enterpriseNameController: enterpriseNameController,
              enterpriseNameFocusNode: enterpriseNameFocusNode,
              bsUserNameFocusNode: bsUserNameFocusNode,
            ),
            UserNameField(
              bsUserNameController: bsUserNameController,
              bsUserNameFocusNode: bsUserNameFocusNode,
              bsPasswordFocusNode: bsPasswordFocusNode,
            ),
            PasswordField(
              bsPasswordController: bsPasswordController,
              bsPasswordFocusNode: bsPasswordFocusNode,
              onSubmit: () async {
                await onSubmit(enterprisesManagerPresenter);
              },
            ),
            SubmitButton(
              onSubmit: () async {
                await onSubmit(enterprisesManagerPresenter);
              },
            ),
          ],
        ),
      ),
    );
  }
}
