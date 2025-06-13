import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GroupOfStores extends StatelessWidget {
  final List<SaleStatisticViewModel> sales;
  const GroupOfStores({
    super.key,
    required this.sales,
  });

  List<MapEntry<String, double>> getSalesByEnterprise(
    HomePresenter homePresenter,
  ) {
    return sales
        .fold(<String, List<SaleStatisticViewModel>>{}, (p, e) {
          final key =
              "${e.EnterprisePersonalizedCode}-${e.EnterpriseFantasyName}";
          p.putIfAbsent(key, () => []).add(e);
          return p;
        })
        .map((key, value) => MapEntry(
            key,
            value.sumLiquidValue(
              filterDay: homePresenter.selectedDate.day,
              filterMonth: homePresenter.selectedDate.month,
              filterYear: homePresenter.selectedDate.year,
            )))
        .entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  List<PieParameter> getPieParameters(HomePresenter homePresenter) {
    final salesByEnterprise = getSalesByEnterprise(homePresenter);
    final pieParameters = <PieParameter>[];

    if (salesByEnterprise.length <= 4) {
      pieParameters.addAll(
        salesByEnterprise.map(
          (e) => PieParameter(value: e.value, title: e.key),
        ),
      );
    } else {
      final topFour = salesByEnterprise.take(4);
      final othersTotal = salesByEnterprise.skip(4).fold<double>(
            0,
            (sum, e) => sum + e.value,
          );

      pieParameters.addAll(
        topFour.map(
          (e) => PieParameter(value: e.value, title: e.key),
        ),
      );
      pieParameters.add(
        PieParameter(value: othersTotal, title: R.string.anothersEnterprises),
      );
    }

    return pieParameters;
  }

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();

    return Container(
      decoration: ContainerDecoration.decoration,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            R.string.groupOfStores,
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            R.string.salesOfTheDay,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          ChartPie(pieParameters: getPieParameters(homePresenter)),
          DefaultButton(
            onTap: resumePresenter.goToGroupSummaryPage,
            title: R.string.groupSummary,
          ),
        ],
      ),
    );
  }
}
