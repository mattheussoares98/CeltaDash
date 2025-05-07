import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class GroupSummaryDetailsPage extends StatelessWidget {
  final double groupSalesTotalLiquid;
  final void Function(bool changedDayOrMonth) changeDayOrMonth;
  final bool selectedDay;
  final List<SaleMovementViewModel> saleMovements;
  const GroupSummaryDetailsPage({
    super.key,
    required this.groupSalesTotalLiquid,
    required this.changeDayOrMonth,
    required this.selectedDay,
    required this.saleMovements,
  });
  List<MapEntry<String, double>> getSalesByEnterprise(
    HomePresenter homePresenter,
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
              filterDay:
                  selectedDay == true ? homePresenter.selectedDate.day : null,
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

    final salesByEnterprise = getSalesByEnterprise(homePresenter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: SelectDayOrMonthItems(change: changeDayOrMonth),
        ),
        const SizedBox(height: 8),
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
