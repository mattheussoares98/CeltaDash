import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../main/composites/composites.dart';
import '../../../../../presentation/protocols/protocols.dart';
import '../../../../../validation/validators/validators.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class EditGoalFieldAndButtons extends StatelessWidget {
  final TextEditingController goalController;
  final FocusNode goalFocusNode;
  final VoidCallback changeShowEditGoal;
  const EditGoalFieldAndButtons({
    super.key,
    required this.goalController,
    required this.goalFocusNode,
    required this.changeShowEditGoal,
  });

  static final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumePresenter = Get.find<ResumePresenter>();

    Future<void> changeGoal() async {
      if (formKey.currentState?.validate() == true) {
        await resumePresenter.setGoal(goalController.text.toDouble());

        changeShowEditGoal.call();
      }
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: goalFocusNode,
            controller: goalController,
            decoration: FormFieldDecoration.decoration(
              context: context,
              labelText: R.string.goal.addBrazilianCoin(),
            ),
            onFieldSubmitted: (_) => changeGoal(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              BrazilianRealInputFormatter(),
            ],
            validator: (value) => ValidationComposite([
              const RequiredFieldValidation(),
            ]).validate(value)?.description,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: changeShowEditGoal,
                child: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? CupertinoIcons.xmark
                      : Icons.cancel,
                  color: Colors.red,
                ),
              ),
              InkWell(
                onTap: changeGoal,
                child: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? CupertinoIcons.check_mark
                      : Icons.save,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
