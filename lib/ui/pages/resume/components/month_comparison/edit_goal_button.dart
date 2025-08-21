import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../home/home.dart';

class EditGoalButton extends StatelessWidget {
  final VoidCallback changeShowEditGoal;
  const EditGoalButton({super.key, required this.changeShowEditGoal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homePresenter = Get.find<HomePresenter>();
    final now = DateTime.now();

    return TextButton.icon(
      onPressed:
          homePresenter.selectedDate.isBefore(DateTime(now.year, now.month))
              ? null
              : changeShowEditGoal,
      icon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.pencil
            : Icons.edit,
      ),
      label: Text(R.string.editGoal),
    );
  }
}
