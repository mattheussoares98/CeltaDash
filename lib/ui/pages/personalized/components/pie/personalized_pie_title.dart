import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../home/home.dart';

class PersonalizedPieTitle extends StatelessWidget {
  final SaleStatisticViewModel sale;
  final CategoryGroupingType? selectedCategoryGroupingType;
  final PeriodGroupingType? selectedPeriodGroupingType;
  const PersonalizedPieTitle({
    super.key,
    required this.sale,
    required this.selectedCategoryGroupingType,
    required this.selectedPeriodGroupingType,
  });

  @override
  Widget build(BuildContext context) {
    String title = "";
    if (selectedCategoryGroupingType == CategoryGroupingType.cashierOperator) {
      title += sale.CashierOperator!;
    } else if (selectedCategoryGroupingType ==
        CategoryGroupingType.paymentFinalization) {
      title += sale.PaymentFinalization!;
    } else if (selectedCategoryGroupingType ==
        CategoryGroupingType.paymentModality) {
      title += sale.PaymentModality!;
    } else if (selectedCategoryGroupingType ==
        CategoryGroupingType.productDepartment) {
      title += sale.ProductDepartment!;
    } else if (selectedCategoryGroupingType ==
        CategoryGroupingType.productSection) {
      title += sale.ProductSection!;
    } else if (selectedCategoryGroupingType == CategoryGroupingType.product) {
      title += sale.Product!;
    } else if (selectedCategoryGroupingType == CategoryGroupingType.seller) {
      title += sale.Seller!;
    } else if (selectedCategoryGroupingType ==
        CategoryGroupingType.enterprise) {
      title += sale.EnterpriseFantasyName!;
    }

    if (title.isNotEmpty) {
      title += "\n";
    }

    if (selectedPeriodGroupingType == PeriodGroupingType.year) {
      title += sale.Year.toString();
    } else if (selectedPeriodGroupingType == PeriodGroupingType.month) {
      final formatter = DateFormat('MMMM', 'pt_BR');
      final DateTime date = DateTime(DateTime.now().year, sale.Month!.toInt());

      title += formatter.format(date);
    } else if (selectedPeriodGroupingType == PeriodGroupingType.day) {
      final formatter = DateFormat.yMd("pt_BR");
      title += "${R.string.day} ${formatter.format(sale.Date!)}";
    } else if (selectedPeriodGroupingType == PeriodGroupingType.hour) {
      final formatter = DateFormat("y/MM/dd", "pt_BR");
      title += "${R.string.day} ${formatter.format(sale.Date!)} ${sale.Hour}"
          .replaceAll(RegExp(r'\n'), '~');
    }

    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
