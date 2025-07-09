import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import 'new_enterprise.dart';

class AddNewEnterprise extends StatefulWidget {
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

  @override
  State<AddNewEnterprise> createState() => _AddNewEnterpriseState();
}

class _AddNewEnterpriseState extends State<AddNewEnterprise> {
  final _formKey = GlobalKey<FormState>();
  final _expansibleController = ExpansibleController();

  Future<void> onSubmit(
    EnterprisesManagerPresenter enterprisesManagerPresenter,
  ) async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    bool added = await enterprisesManagerPresenter.addNewEnterprise(
      enterpriseName: widget.enterpriseNameController.text,
      userName: widget.bsUserNameController.text,
      userPassword: widget.bsPasswordController.text,
    );

    if (added && mounted) {
      widget.enterpriseNameController.clear();
      widget.bsUserNameController.clear();
      widget.bsPasswordController.clear();
      _expansibleController.collapse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();

    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: ContainerDecoration.defaultDecoration,
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          controller: _expansibleController,
          childrenPadding: const EdgeInsets.all(4),
          title: Text(
            R.string.addNewEnterprise,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          onExpansionChanged: (value) {
            if (value) {
              widget.enterpriseNameFocusNode.requestFocus();
            }
          },
          children: [
            EnterpriseNameField(
              enterpriseNameController: widget.enterpriseNameController,
              enterpriseNameFocusNode: widget.enterpriseNameFocusNode,
              bsUserNameFocusNode: widget.bsUserNameFocusNode,
            ),
            UserNameField(
              bsUserNameController: widget.bsUserNameController,
              bsUserNameFocusNode: widget.bsUserNameFocusNode,
              bsPasswordFocusNode: widget.bsPasswordFocusNode,
            ),
            PasswordField(
              bsPasswordController: widget.bsPasswordController,
              bsPasswordFocusNode: widget.bsPasswordFocusNode,
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
