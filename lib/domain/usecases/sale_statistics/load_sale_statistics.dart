// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:get/get.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

export 'package:celta_dash/features/sale_statistics/domain/entities/get_sale_statistics_params.dart';

abstract class LoadSaleStatistics {
  Future<List<SaleStatisticsEntity>> get(GetSaleStatisticsParams params);
}

extension GetSaleStatisticsParamsPeriodType on GetSaleStatisticsParams {
  PeriodGroupingType? get selectedPeriod {
    for (var periodType in PeriodGroupingType.values) {
      if (_periodGroupIsEnabled(periodType, this)) {
        return periodType;
      }
    }
    return null;
  }
}

extension GetSaleStatisticsParamsEnterprise on GetSaleStatisticsParams {
  List<EcEnterpriseViewModel>? get selectedsEnterprises {
    final homePresenter = Get.find<HomePresenter>();
    final enterprises = homePresenter.enterprises;
    final selectedIds = this.enterpriseIds;
    final selectedsEnterprises = enterprises
        ?.where((e) => selectedIds?.contains(e.id?.toInt()) == true)
        .toList();

    return selectedsEnterprises;
  }
}

extension GetSaleStatisticsParamsCategoryGroupingsType
    on GetSaleStatisticsParams {
  List<CategoryGroupingType> get selectedsCategories {
    final selecteds = <CategoryGroupingType>[];
    for (var category in CategoryGroupingType.values) {
      if (_categoryIsEnabled(category, this)) {
        selecteds.add(category);
        continue;
      }
    }
    return selecteds;
  }
}

bool _categoryIsEnabled(
  CategoryGroupingType type,
  GetSaleStatisticsParams params,
) {
  switch (type) {
    case CategoryGroupingType.product:
      return params.groupByProduct == true;
    case CategoryGroupingType.cashierOperator:
      return params.groupByCashierOperator == true;
    case CategoryGroupingType.seller:
      return params.groupBySeller == true;
    case CategoryGroupingType.paymentFinalization:
      return params.groupByPaymentFinalization == true;
    case CategoryGroupingType.paymentModality:
      return params.groupByPaymentModality == true;
    case CategoryGroupingType.productSection:
      return params.groupByProductSection == true;
    case CategoryGroupingType.productDepartment:
      return params.groupByProductDepartment == true;
  }
}

bool _periodGroupIsEnabled(
  PeriodGroupingType type,
  GetSaleStatisticsParams params,
) {
  switch (type) {
    case PeriodGroupingType.day:
      return params.groupByDay == true;
    case PeriodGroupingType.month:
      return params.groupByMonth == true;
    case PeriodGroupingType.year:
      return params.groupByYear == true;
    case PeriodGroupingType.hour:
      return params.groupByHour == true;
  }
}
