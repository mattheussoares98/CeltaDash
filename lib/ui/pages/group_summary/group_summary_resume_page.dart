import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class GroupSummaryResumePage extends StatelessWidget {
  final void Function(bool) changeDayOrMonth;
  final double groupSalesTotalLiquid;
  final List<SaleMovementViewModel> groupSales;
  final int groupSalesQuantity;
  const GroupSummaryResumePage({
    super.key,
    required this.changeDayOrMonth,
    required this.groupSalesTotalLiquid,
    required this.groupSales,
    required this.groupSalesQuantity,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectDayOrMonthItems(change: changeDayOrMonth),
            const SizedBox(height: 8),
            Column(
              children: [
                Indicator(
                  firstTitle:
                      '${R.string.totalSalesGroup} (${homePresenter.enterprises?.length ?? 1} ${R.string.enterprises})',
                  secondTitle: R.string.averageSalesGroup,
                  firstValue: groupSalesTotalLiquid
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  secondValue: (groupSalesTotalLiquid /
                          (homePresenter.enterprises?.length ?? 1))
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  icon: Icons.monetization_on,
                ),
                const SizedBox(height: 4),
                Indicator(
                  firstTitle: R.string.salesQuantity,
                  secondTitle: R.string.salesQuantityAverage,
                  firstValue: groupSales.quantitySales().toString(),
                  secondValue: (groupSalesQuantity /
                          (homePresenter.enterprises?.length ?? 1))
                      .toString()
                      .toBrazilianNumber(),
                  icon: Icons.person,
                ),
                //TODO add averate ticket by sale and devolutions
              ],
            ),
          ],
        ),
      ),
    );
  }
}
