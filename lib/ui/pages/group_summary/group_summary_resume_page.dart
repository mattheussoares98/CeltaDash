import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class GroupSummaryResumePage extends StatelessWidget {
  final double groupSalesTotalLiquid;
  final List<SaleStatisticViewModel> groupSales;
  final int groupSalesQuantity;
  const GroupSummaryResumePage({
    super.key,
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
            Column(
              children: [
                Indicator(
                  firstTitle:
                      '${R.string.totalSalesGroup} (${homePresenter.enterprises?.length ?? 1} ${R.string.enterprises})',
                  secondTitle: R.string.averageSalesGroup,
                  firstValue: groupSalesTotalLiquid
                      .toString()
                      .toBRL()
                      .addBrazilianCoin(),
                  secondValue:
                      (groupSalesTotalLiquid /
                              (homePresenter.enterprises?.length ?? 1))
                          .toString()
                          .toBRL()
                          .addBrazilianCoin(),
                  icon: Icons.monetization_on,
                ),
                const SizedBox(height: 4),
                Indicator(
                  firstTitle: R.string.salesQuantity,
                  secondTitle: R.string.salesQuantityAverage,
                  firstValue: groupSales.quantitySales().toString().toBRL(0),
                  secondValue:
                      (groupSalesQuantity /
                              (homePresenter.enterprises?.length ?? 1))
                          .toString()
                          .toBRL()
                          .addBrazilianCoin(),
                  icon: Icons.person,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
