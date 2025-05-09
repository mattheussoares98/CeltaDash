import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages.dart';
import 'components.dart';

class DailySales extends StatelessWidget {
  final ScrollController scrollController;
  final List<SaleMovementViewModel> saleMovements;
  const DailySales({
    super.key,
    required this.scrollController,
    required this.saleMovements,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();

    return SalesInformations(
      scrollController: scrollController,
      title: R.string.salesOfTheDay,
      totalSales: saleMovements.sumLiquidValue(
        enterprise: homePresenter.selectedEnterprise,
        filterYear: homePresenter.selectedDate.year,
        filterMonth: homePresenter.selectedDate.month,
        filterDay: homePresenter.selectedDate.day,
      ),
      bottomChildren: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: DefaultNavigateButton(
                onTap: resumePresenter.goToPaymentsTypePage,
                title: R.string.paymentsType,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DefaultNavigateButton(
                onTap: resumePresenter.goToDepartmentsPage,
                title: R.string.departments,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultNavigateButton(
              onTap: resumePresenter.goToCompareDays,
              title: R.string.compareDays,
            ),
          ],
        ),
      ],
      leftButton: null,
      rightButton: null,
      rightChildren: [
        Text(
          "${R.string.salesQuantity}\n${saleMovements.quantitySales(
            enterprise: homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year,
            filterMonth: homePresenter.selectedDate.month,
            filterDay: homePresenter.selectedDate.day,
          )}",
        ),
        Text(
          "${R.string.ticketAverage}\n${(saleMovements.ticketAverage(
            homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year,
            filterMonth: homePresenter.selectedDate.month,
            filterDay: homePresenter.selectedDate.day,
          )).toString().toBrazilianNumber().addBrazilianCoin()}",
        ),
        // Text(
        // TODO  "Request Cardoso to add products by sale quantity and average price",
        // ),
      ],
    );
  }
}
