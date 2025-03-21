import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class DailyAnalysis extends StatelessWidget {
  const DailyAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration.decoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Análise diária",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "Sexta-feirassss de 2025",
              textAlign: TextAlign.center,
            ), //TODO create a Model in HomePresenter to control selected data and selected enterprise
            CompareTimesResult(
              betterTime: "18:00 ~ 18:59",
              betterValue: 3622.89,
              worstTime: "22:00 ~ 22:59",
              worstValue: 8.59,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                PersonalizedDialogPage.open(
                  context: context,
                  page: Scaffold(body: Center(child: Text("Daily analysis"))),
                );
              },
              label: Text("Compare days"),
              icon: Icon(Icons.arrow_outward_rounded, color: Colors.white),
              iconAlignment: IconAlignment.end,
            ),
          ],
        ),
      ),
    );
  }
}
