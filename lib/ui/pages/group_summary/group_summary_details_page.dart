import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

bool _showAnimation = true;

class GroupSummaryDetailsPage extends StatelessWidget {
  final double groupSalesTotalLiquid;
  final List<SaleStatisticViewModel> saleStatistics;
  const GroupSummaryDetailsPage({
    super.key,
    required this.groupSalesTotalLiquid,
    required this.saleStatistics,
  });
  List<MapEntry<String, double>> getSalesByEnterprise(
    HomePresenter homePresenter,
    ResumePresenter resumePresenter,
  ) {
    return saleStatistics
        .fold(<String, List<SaleStatisticViewModel>>{}, (p, e) {
          final key =
              "${e.EnterprisePersonalizedCode}-${e.EnterpriseFantasyName}";
          p.putIfAbsent(key, () => []).add(e);
          return p;
        })
        .map((key, value) => MapEntry(
            key,
            value.sumLiquidValue(
              filterDay: resumePresenter.selectedPeriod == PeriodType.daily
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

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScrollableTableItem(
          titleMinHeight: isPortrait ? 40 : 25,
          selectedPeriodType: resumePresenter.selectedPeriod,
          pdfFileName: R.string.groupSummary,
          hideShowAnimation: () => _showAnimation = !_showAnimation,
          columnIndexToCompareAndDetachBetterAndWorstValue: 1,
          columnsIndexToSum: [1],
          indexToSort: 1,
          columnsWidths: [180, 90, 80],
          showAnimation: _showAnimation,
          titles: [
            PersonalizedTableCell(value: R.string.enterprise, isTitle: true),
            PersonalizedTableCell(value: R.string.sales, isTitle: true),
            PersonalizedTableCell(value: R.string.share, isTitle: true),
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
