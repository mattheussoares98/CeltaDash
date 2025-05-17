import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FloatingButton extends StatefulWidget {
  final WebEnterprisesPresenter presenter;
  const FloatingButton({super.key, required this.presenter});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  final baseUrlController = TextEditingController();
  final enterpriseNameController = TextEditingController();
  final bsUserNameController = TextEditingController();
  final bsPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    baseUrlController.dispose();
    enterpriseNameController.dispose();
    bsUserNameController.dispose();
    bsPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // wrap content vertically
                      children: [
                        TextFormField(
                          controller: enterpriseNameController,
                          decoration: FormFieldDecoration.decoration(
                            context: context,
                            labelText: R.string.enterpriseName,
                            hintText: R.string.enterpriseName,
                          ),
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
                          decoration: FormFieldDecoration.decoration(
                            context: context,
                            labelText: R.string.url,
                            hintText: R.string.url,
                          ),
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
                          decoration: FormFieldDecoration.decoration(
                            context: context,
                            labelText: R.string.bsUserName,
                            hintText: R.string.bsUserName,
                          ),
                          validator: (value) {
                            return ValidationComposite([
                              RequiredFieldValidation(),
                            ]).validate(value)?.description;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: bsPasswordController,
                          obscureText: true,
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
            onPress: () async {
              if (formKey.currentState?.validate() == true) {
                await widget.presenter.addNewEnterprise(
                  bsUserName: bsUserNameController.text,
                  bsPassword: bsPasswordController.text,
                  baseUrl: baseUrlController.text,
                  enterpriseName: enterpriseNameController.text,
                  docRef:
                      FirebaseFirestore.instance.collection("enterprises").doc(
                            enterpriseNameController.text
                                .toLowerCase()
                                .removeWhiteSpaces(),
                          ),
                );
                Navigator.of(context).pop();
                baseUrlController.clear();
                enterpriseNameController.clear();
                bsUserNameController.clear();
                bsPasswordController.clear();
              }
            },
            onCancelPress: () async {
              baseUrlController.clear();
              enterpriseNameController.clear();
              bsUserNameController.clear();
              bsPasswordController.clear();
            });
      },
      child: Icon(Icons.add),
    );
  }
}
