import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../pages.dart';

class GoalValue extends StatelessWidget {
  final double goalLiquidValue;
  const GoalValue({super.key, required this.goalLiquidValue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumePresenter = Get.find<ResumePresenter>();

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
        text: "Meta",
        children: [
          TextSpan(
            text: " R\$",
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
          TextSpan(
            text: resumePresenter.firebaseEnterpriseGoal == null
                ? goalLiquidValue.toString().toBRL()
                : resumePresenter.firebaseEnterpriseGoal!.value
                      ?.toString()
                      .toBRL(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
