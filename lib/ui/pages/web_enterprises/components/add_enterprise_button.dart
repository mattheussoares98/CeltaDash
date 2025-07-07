import 'package:flutter/material.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class AddEnterpriseButton extends StatefulWidget {
  final WebEnterprisesPresenter presenter;
  const AddEnterpriseButton({super.key, required this.presenter});

  @override
  State<AddEnterpriseButton> createState() => _AddEnterpriseButtonState();
}

class _AddEnterpriseButtonState extends State<AddEnterpriseButton> {
  final baseUrlController = TextEditingController();
  final enterpriseNameController = TextEditingController();
  final bsUserNameController = TextEditingController();
  final bsPasswordController = TextEditingController();
  final urlFocusNode = FocusNode();
  final bsUserFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    baseUrlController.dispose();
    enterpriseNameController.dispose();
    bsUserNameController.dispose();
    bsPasswordController.dispose();
  }

  Future<void> _addEnterprise() async {
    if (formKey.currentState?.validate() == true) {
      await widget.presenter.addNewEnterprise(
        bsUserName: bsUserNameController.text,
        bsPassword: bsPasswordController.text,
        baseUrl: baseUrlController.text,
        enterpriseName: enterpriseNameController.text,
        doOnSucceeds: () {
          Navigator.of(context).pop();
          baseUrlController.clear();
          enterpriseNameController.clear();
          bsUserNameController.clear();
          bsPasswordController.clear();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        notificationDialog(
            context: context,
            titleMessage: R.string.newEnterprise,
            cancelMessage: R.string.cancel,
            confirmMessage: R.string.add,
            canPop: false,
            closeDialogOnConfirmPress: false,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // wrap content vertically
                        children: [
                          TextFormField(
                            autofocus: true,
                            controller: enterpriseNameController,
                            decoration: FormFieldDecoration.decoration(
                              context: context,
                              labelText: R.string.enterpriseName,
                              hintText: R.string.enterpriseName,
                            ),
                            onFieldSubmitted: (_) {
                              urlFocusNode.requestFocus();
                            },
                            validator: (value) {
                              return ValidationComposite([
                                RequiredFieldValidation(),
                                MinLengthValidation(size: 2),
                              ]).validate(value)?.description;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: baseUrlController,
                            focusNode: urlFocusNode,
                            decoration: FormFieldDecoration.decoration(
                              context: context,
                              labelText: R.string.url,
                              hintText: R.string.url,
                            ),
                            onFieldSubmitted: (_) {
                              bsUserFocusNode.requestFocus();
                            },
                            validator: (value) {
                              return ValidationComposite([
                                RequiredFieldValidation(),
                                MinLengthValidation(size: 2),
                                UrlFieldValidation(),
                              ]).validate(value)?.description;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: bsUserNameController,
                            focusNode: bsUserFocusNode,
                            decoration: FormFieldDecoration.decoration(
                              context: context,
                              labelText: R.string.bsUserName,
                              hintText: R.string.bsUserName,
                            ),
                            onFieldSubmitted: (_) {
                              passwordFocusNode.requestFocus();
                            },
                            validator: (value) {
                              return ValidationComposite([
                                RequiredFieldValidation(),
                              ]).validate(value)?.description;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: bsPasswordController,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            onFieldSubmitted: (_) async {
                              await _addEnterprise();
                            },
                            decoration: FormFieldDecoration.decoration(
                              context: context,
                              labelText: R.string.bsPassword,
                              hintText: R.string.bsPassword,
                            ),
                            validator: (value) {
                              return ValidationComposite([
                                RequiredFieldValidation(),
                              ]).validate(value)?.description;
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onPress: _addEnterprise,
            onCancelPress: () async {
              baseUrlController.clear();
              enterpriseNameController.clear();
              bsUserNameController.clear();
              bsPasswordController.clear();
            });
      },
      icon: Icon(Icons.add),
    );
  }
}
