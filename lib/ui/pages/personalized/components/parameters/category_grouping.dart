import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import '../components.dart';

class CategoryGrouping extends StatefulWidget {
  const CategoryGrouping({super.key});

  @override
  State<CategoryGrouping> createState() => _CategoryGroupingState();
}

class _CategoryGroupingState extends State<CategoryGrouping> {
  bool isEnabled(CategoryGroupingType type) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final params = personalizedPresenter.currentSelectedParams;
    switch (type) {
      case CategoryGroupingType.product:
        return params?.groupByProduct == true;
      case CategoryGroupingType.cashierOperator:
        return params?.groupByCashierOperator == true;
      case CategoryGroupingType.seller:
        return params?.groupBySeller == true;
      case CategoryGroupingType.paymentFinalization:
        return params?.groupByPaymentFinalization == true;
      case CategoryGroupingType.paymentModality:
        return params?.groupByPaymentModality == true;
      case CategoryGroupingType.productSection:
        return params?.groupByProductSection == true;
      case CategoryGroupingType.productDepartment:
        return params?.groupByProductDepartment == true;
    }
  }

  String getSelectedsCategories() {
    final params = Get.find<PersonalizedPresenter>().currentSelectedParams;
    if (params == null) return "";

    final selectedCategories = CategoryGroupingType.values
        .where((type) => params.isCategoryGroupingSelected(type));

    return selectedCategories.map((type) => type.name).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final selecteds = getSelectedsCategories();

    return DefaultExpansionTile(
      title:
          "${R.string.groupCategory} ${selecteds.isEmpty ? "" : '($selecteds)'}",
      children: CategoryGroupingType.values
          .map(
            (e) => CheckBoxItem(
              title: e.name,
              value: isEnabled(e),
              onTap: () {
                setState(() {
                  personalizedPresenter.changeCategoryGroupingType(e);
                });
              },
            ),
          )
          .toList(),
    );
  }
}
