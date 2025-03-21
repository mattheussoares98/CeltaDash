import 'package:flutter/material.dart';

import '../../../components/components.dart';

class SetGoalButton extends StatelessWidget {
  const SetGoalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        PersonalizedDialogPage.open(
          context: context,
          page: Scaffold(body: Center(child: Text("Set goal"))),
        );
      },
      child: Text("" + "Set goal"),
    );
  }
}
