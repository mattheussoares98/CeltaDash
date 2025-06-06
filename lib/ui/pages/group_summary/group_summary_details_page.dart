import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class GroupSummaryDetailsPage extends StatelessWidget {
  final double groupSalesTotalLiquid;
  final List<SaleMovementViewModel> saleMovements;
  const GroupSummaryDetailsPage({
    super.key,
    required this.groupSalesTotalLiquid,
    required this.saleMovements,
  });
  List<MapEntry<String, double>> getSalesByEnterprise(
    HomePresenter homePresenter,
    ResumePresenter resumePresenter,
  ) {
    return saleMovements
        .fold(<String, List<SaleMovementViewModel>>{}, (p, e) {
          final key =
              "${e.EnterprisePersonalizedCode}-${e.EnterpriseFantasyName}";
          p.putIfAbsent(key, () => []).add(e);
          return p;
        })
        .map((key, value) => MapEntry(
            key,
            value.sumLiquidValue(
              filterDay: resumePresenter.selectedPeriodValue == PeriodType.daily
                  ? homePresenter.selectedDate.day
                  : null,
              filterMonth: homePresenter.selectedDate.month,
              filterYear: homePresenter.selectedDate.year,
            )))
        .entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find<HomePresenter>();
    ResumePresenter resumePresenter = Get.find<ResumePresenter>();

    final salesByEnterprise =
        getSalesByEnterprise(homePresenter, resumePresenter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableItem(
          columnIndexToCompareAndDetachBetterAndWorstValue: 1,
          columnsIndexToSum: [1],
          indexToSort: 1,
          tableColumnWidth: {
            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.5),
          },
          titleMinHeight: 40,
          titles: [
            PersonalizedTableCell(value: R.string.enterprise),
            PersonalizedTableCell(value: R.string.sales),
            PersonalizedTableCell(value: R.string.share),
          ],
          rowValues: salesByEnterprise
              .map((e) => [
                    PersonalizedTableCell(value: e.key),
                    PersonalizedTableCell(
                      value: e.value,
                      isMoney: true,
                    ),
                    PersonalizedTableCell(
                      value: e.value / groupSalesTotalLiquid * 100,
                      isPercentage: true,
                    ),
                  ])
              .toList(),
        ),
      ],
    );
  }
}
