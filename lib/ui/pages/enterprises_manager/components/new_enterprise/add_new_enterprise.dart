import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
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

  void onSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Card(
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
            onSubmit: onSubmit, //TODO implement
          ),
          SubmitButton(onSubmit: onSubmit),
        ],
      ),
    );
  }
}
