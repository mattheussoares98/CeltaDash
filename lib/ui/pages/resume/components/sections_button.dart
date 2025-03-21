import 'package:flutter/material.dart';

import '../../../components/components.dart';

class SectionsButton extends StatelessWidget {
  const SectionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        PersonalizedDialogPage.open(
          context: context,
          page: Scaffold(body: Center(child: Text("Sections"))),
        );
      },
      child: Text("" + "Sections"),
    );
  }
}
