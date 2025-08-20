import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class EditGoalButton extends StatelessWidget {
  final VoidCallback changeShowEditGoal;
  const EditGoalButton({super.key, required this.changeShowEditGoal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: changeShowEditGoal,
      icon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.pencil
            : Icons.edit,
      ),
      label: Text(R.string.editGoal),
    );
  }
}
