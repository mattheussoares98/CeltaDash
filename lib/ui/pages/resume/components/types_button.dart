import 'package:flutter/material.dart';

import '../../../components/components.dart';

class TypesButton extends StatelessWidget {
  const TypesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        PersonalizedDialogPage.open(
          context: context,
          page: Scaffold(body: Center(child: Text("Types"))),
        );
      },
      child: Text("" + "Types"),
    );
  }
}
