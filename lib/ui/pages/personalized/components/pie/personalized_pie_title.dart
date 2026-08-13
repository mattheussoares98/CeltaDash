import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class PersonalizedPieTitle extends StatelessWidget {
  final SaleStatisticViewModel sale;
  const PersonalizedPieTitle({super.key, required this.sale});

  String getCategoriesTitle() {
    final presenter = Get.find<PersonalizedPresenter>();

    List<String> selectedCategories = [];
    final params = presenter.lastGetStatisticsParams;
    for (var category in CategoryGroupingType.values) {
      switch (category) {
        case CategoryGroupingType.product:
          if (params?.groupByProduct == true) {
            selectedCategories.add(sale.Product ?? "");
          }
          break;
        case CategoryGroupingType.cashierOperator:
          if (params?.groupByCashierOperator == true) {
            selectedCategories.add(sale.CashierOperator ?? "");
          }
          break;
        case CategoryGroupingType.seller:
          if (params?.groupBySeller == true) {
            selectedCategories.add(sale.Seller ?? "");
          }
          break;
        case CategoryGroupingType.paymentFinalization:
          if (params?.groupByPaymentFinalization == true) {
            selectedCategories.add(sale.PaymentFinalization ?? "");
          }
          break;
        case CategoryGroupingType.paymentModality:
          if (params?.groupByPaymentModality == true) {
            selectedCategories.add(sale.PaymentModality ?? "");
          }
          break;
        case CategoryGroupingType.productSection:
          if (params?.groupByProductSection == true) {
            selectedCategories.add(sale.ProductSection ?? "");
          }
          break;
        case CategoryGroupingType.productDepartment:
          if (params?.groupByProductDepartment == true) {
            selectedCategories.add(sale.ProductDepartment ?? "");
          }
          break;
      }
    }

    return "${selectedCategories.join('\n')}\n";
  }

  String getPeriodsTitle() {
    final presenter = Get.find<PersonalizedPresenter>();

    if (presenter.lastGetStatisticsParams?.groupByHour == true) {
      final formatter = DateFormat("y/MM/dd", "pt_BR");
      return "${R.string.day} ${formatter.format(sale.Date!)} ${sale.Hour}"
          .replaceAll(RegExp(r'\n'), '~');
    }

    if (presenter.lastGetStatisticsParams?.groupByDay == true) {
      final formatter = DateFormat.yMd("pt_BR");
      return "${R.string.day} ${formatter.format(sale.Date!)}";
    }

    if (presenter.lastGetStatisticsParams?.groupByMonth == true) {
      final formatter = DateFormat('MMMM', 'pt_BR');
      final DateTime date = DateTime(DateTime.now().year, sale.Month!.toInt()!);
      return formatter.format(date);
    }

    if (presenter.lastGetStatisticsParams?.groupByYear == true) {
      return sale.Year.toString();
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategoriesTitle();
    final periods = getPeriodsTitle();

    return Text(
      categories + periods,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
