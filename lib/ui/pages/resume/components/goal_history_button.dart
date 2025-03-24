import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resume.dart';

class GoalHistoryButton extends StatelessWidget {
  const GoalHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: resumePresenter.goToSetGoalPage,
      child: Text("" + "Histórico de metas"),
    );
  }
}
