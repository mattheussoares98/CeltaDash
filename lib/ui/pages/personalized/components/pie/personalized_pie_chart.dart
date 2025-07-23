import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';
import 'pie.dart';

class PersonalizedPieChart extends StatelessWidget {
  const PersonalizedPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return Obx(() {
      final sales = personalizedPresenter.saleStatistics;
      if (sales == null || sales.isEmpty) {
        return const SizedBox.shrink();
      }

      final selectedCategoryGroupingType = _selectedCategoryGrouping(sales);
      final selectedPeriodGroupingType = _selectedPeriodGrouping(sales);

      sales.sort(
          (saleA, saleB) => saleB.LiquidValue!.compareTo(saleA.LiquidValue!));
      final topFour = sales.take(4);
      final othersTotal = sales.skip(4).fold<double>(
            0.0,
            (sum, e) => sum + (e.LiquidValue?.toDouble() ?? 0),
          );

      return Container(
        decoration: ContainerDecoration.defaultDecoration,
        child: ChartPieWidget(
          showTotalAmount: true,
          pieParameters: [
            ...topFour.map(
              (e) => PieParameter(
                value: e.LiquidValue?.toDouble() ?? 0,
                title: PersonalizedPieTitle(
                  sale: e,
                  selectedCategoryGroupingType: selectedCategoryGroupingType,
                  selectedPeriodGroupingType: selectedPeriodGroupingType,
                ),
                subtitle: Text(e.LiquidValue?.toString()
                        .toBrazilianNumber()
                        .addBrazilianCoin() ??
                    ''),
              ),
            ),
            if (othersTotal > 0)
              PieParameter(
                value: othersTotal,
                title: Text(
                  R.string.anothers,
                  style: theme.textTheme.titleSmall,
                ),
                subtitle: Text(othersTotal
                    .toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin()),
              ),
          ],
        ),
      );
    });
  }
}

CategoryGroupingType? _selectedCategoryGrouping(
  List<SaleStatisticViewModel> sales,
) {
  if (sales.any((e) => e.CashierOperator != null)) {
    return CategoryGroupingType.cashierOperator;
  } else if (sales.any((e) => e.PaymentFinalization != null)) {
    return CategoryGroupingType.paymentFinalization;
  } else if (sales.any((e) => e.PaymentModality != null)) {
    return CategoryGroupingType.paymentModality;
  } else if (sales.any((e) => e.Product != null)) {
    return CategoryGroupingType.product;
  } else if (sales.any((e) => e.ProductSection != null)) {
    return CategoryGroupingType.productSection;
  } else if (sales.any((e) => e.ProductDepartment != null)) {
    return CategoryGroupingType.productDepartment;
  } else if (sales.any((e) => e.Seller != null)) {
    return CategoryGroupingType.seller;
  } else if (sales.any((e) => e.EnterpriseFantasyName != null)) {
    return CategoryGroupingType.enterprise;
  }

  return null;
}

PeriodGroupingType? _selectedPeriodGrouping(
  List<SaleStatisticViewModel> sales,
) {
  if (sales.any((e) => e.Hour != null)) {
    return PeriodGroupingType.hour;
  } else if (sales.any((e) => e.Date != null)) {
    return PeriodGroupingType.day;
  } else if (sales.any((e) => e.Month != null)) {
    return PeriodGroupingType.month;
  } else if (sales.any((e) => e.Year != null)) {
    return PeriodGroupingType.year;
  }
  return null;
}
