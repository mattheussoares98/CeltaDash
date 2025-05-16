import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class BaseUrlField extends StatelessWidget {
  final TextEditingController urlController;
  final void Function() onChange;

  const BaseUrlField({
    super.key,
    required this.urlController,
    required this.onChange,
  });

  Future<void> onPressed(
    WebEnterprisesPresenter webEnterprisesPresenter,
  ) async {
    await webEnterprisesPresenter.changeEnterpriseUrl(
      newUrl: urlController.text,
      docRef: FirebaseFirestore.instance.collection("enterprises").doc(
            webEnterprisesPresenter.selectedEnterprise?.firebaseId,
          ),
    );
    onChange();
  }

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: R.string.url,
          hintText: R.string.url,
          suffixIcon: IconButton(
            onPressed: () async {
              await onPressed(webEnterprisesPresenter);
            },
            icon: Icon(Icons.save),
          ),
        ),
        onFieldSubmitted: (_) async {
          await onPressed(webEnterprisesPresenter);
        },
        controller: urlController,
      ),
    );
  }
}
