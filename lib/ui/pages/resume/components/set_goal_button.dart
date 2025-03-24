import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resume.dart';

class SetGoalButton extends StatelessWidget {
  const SetGoalButton({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);

    return TextButton(
      onPressed: resumePresenter.goToSetGoalPage,
      child: Text("" + "Set goal"),
    );
  }
}
