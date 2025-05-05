import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class DailyAnalysis extends StatelessWidget {
  final List<SaleMovementViewModel> saleMovements;
  const DailyAnalysis({
    super.key,
    required this.saleMovements,
  });

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    final now = DateTime.now();

    final betterAverage = saleMovements.hourAverage(
      getBest: true,
      enterprise: homePresenter.selectedEnterprise,
      filterYear: now.year,
    );
    final worstAverage = saleMovements.hourAverage(
      getBest: false,
      enterprise: homePresenter.selectedEnterprise,
      filterYear: now.year,
    );

    return Container(
      decoration: ContainerDecoration.decoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              R.string.dailyAnalysisAverage,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "${R.string.all} ${DateFormat.EEEE('pt_BR').format(now)}s ${R.string.of.toLowerCase()} ${now.year}",
              textAlign: TextAlign.center,
            ),
            CompareTimesResult(
              betterTime: betterAverage.hour,
              betterValue: betterAverage.value,
              worstTime: worstAverage.hour,
              worstValue: worstAverage.value,
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
