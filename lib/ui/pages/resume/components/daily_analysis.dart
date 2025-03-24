import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../resume.dart';
import 'components.dart';

class DailyAnalysis extends StatelessWidget {
  const DailyAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);

    return Container(
      decoration: ContainerDecoration.decoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              R.string.dailyAnalysis,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "${R.string.all} ${DateFormat.EEEE('pt_BR').format(DateTime.now())}s ${R.string.of.toLowerCase()} ${DateTime.now().year}",
              textAlign: TextAlign.center,
            ), //TODO create a Model in HomePresenter to control selected data and selected enterprise
            CompareTimesResult(
              betterTime: "18:00 ~ 18:59",
              betterValue: 3622.89,
              worstTime: "22:00 ~ 22:59",
              worstValue: 8.59,
              betterTimeMessage: R.string.bestHourOfTheDay,
              worstTimeMessage: R.string.worstHourOfTheDay,
            ),
            const SizedBox(height: 8),
            DefaultNavigateButton(
              onTap: resumePresenter.goToCompareDays,
              title: R.string.compareDays,
              icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
