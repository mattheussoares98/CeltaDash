import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/components.dart';
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
              child: DefaultButton(
                onTap: resumePresenter.goToPaymentsTypePage,
                title: R.string.payments,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DefaultButton(
                onTap: resumePresenter.goToDepartmentsPage,
                title: R.string.departments,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultButton(
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
          R.string.salesQuantity,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          saleMovements
              .quantitySales(
                enterprise: homePresenter.selectedEnterprise,
                filterYear: homePresenter.selectedDate.year,
                filterMonth: homePresenter.selectedDate.month,
                filterDay: homePresenter.selectedDate.day,
              )
              .toString()
              .toBrazilianNumber(0),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
        Text(
          R.string.ticketAverage,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          (saleMovements.ticketAverage(
            homePresenter.selectedEnterprise,
            filterYear: homePresenter.selectedDate.year,
            filterMonth: homePresenter.selectedDate.month,
            filterDay: homePresenter.selectedDate.day,
          )).toString().toBrazilianNumber().addBrazilianCoin(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}
