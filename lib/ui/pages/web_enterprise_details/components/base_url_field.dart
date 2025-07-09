import 'package:celta_dash/presentation/protocols/protocols.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/composites/composites.dart';
import '../../../../validation/validators/validators.dart';
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
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    await webEnterprisesPresenter.changeEnterpriseUrl(urlController.text);
    onChange();
  }

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: FormFieldDecoration.decoration(
            context: context,
            labelText: R.string.url,
            hintText: R.string.url,
            suffixIcon: IconButton(
              onPressed: () async {
                await onPressed(webEnterprisesPresenter);
              },
              icon: const Icon(Icons.save),
            ),
          ),
          validator: (value) {
            return ValidationComposite([
              const RequiredFieldValidation(),
              UrlFieldValidation(),
            ]).validate(value)?.description;
          },
          onFieldSubmitted: (_) async {
            await onPressed(webEnterprisesPresenter);
          },
          controller: urlController,
        ),
      ),
    );
  }
}
