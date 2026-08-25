// lib/features/login/presentation/pages/components/enterprise_field.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterpriseField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const EnterpriseField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'Empresa'.hardcoded,
      hintText: 'Empresa'.hardcoded,
      prefixIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.building_2_fill,
        materialIcon: Icons.business,
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => nextFocusNode.requestFocus(),
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(2),
      ]),
    );
  }
}
