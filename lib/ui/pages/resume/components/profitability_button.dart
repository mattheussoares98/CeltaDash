import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class ProfitabilityButton extends StatelessWidget {
  const ProfitabilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        PersonalizedDialogPage.open(
          context: context,
          page: Scaffold(body: Center(child: Text("Profitability"))),
        );
      },
      label: Text(R.string.profitability),
      icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
      iconAlignment: IconAlignment.end,
    );
  }
}
