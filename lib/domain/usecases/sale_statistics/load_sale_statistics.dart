// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:celta_dash/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../ui/pages/pages.dart';
import '../../entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class LoadSaleStatistics {
  Future<List<SaleStatisticsEntity>> get(GetSaleStatisticsParams params);
}

class GetSaleStatisticsParams extends Equatable implements DateRangeParams {
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final List<int>? enterpriseIds;
  final bool? groupByEnterprise;
  final bool? groupByYear;
  final bool? groupByMonth;
  final bool? groupByDay;
  final bool? groupByHour;
  final bool? groupByProduct;
  final bool? groupByProductDepartment;
  final bool? groupByProductSection;
  final bool? groupByPaymentFinalization;
  final bool? groupByPaymentModality;
  final bool? groupByCashierOperator;
  final bool? groupBySeller;
  final int? topCount;

  const GetSaleStatisticsParams({
    required this.startDate,
    required this.endDate,
    this.enterpriseIds,
    this.groupByEnterprise,
    this.groupByYear,
    this.groupByMonth,
    this.groupByDay,
    this.groupByHour,
    this.groupByProduct,
    this.groupByProductDepartment,
    this.groupByProductSection,
    this.groupByPaymentFinalization,
    this.groupByPaymentModality,
    this.groupByCashierOperator,
    this.groupBySeller,
    this.topCount,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    enterpriseIds,
    groupByEnterprise,
    groupByYear,
    groupByMonth,
    groupByDay,
    groupByHour,
    groupByProduct,
    groupByProductDepartment,
    groupByProductSection,
    groupByPaymentFinalization,
    groupByPaymentModality,
    groupByCashierOperator,
    groupBySeller,
    topCount,
  ];

  GetSaleStatisticsParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<int>? enterpriseIds,
    bool? groupByEnterprise,
    bool? groupByYear,
    bool? groupByMonth,
    bool? groupByDay,
    bool? groupByHour,
    bool? groupByProduct,
    bool? groupByProductDepartment,
    bool? groupByProductSection,
    bool? groupByPaymentFinalization,
    bool? groupByPaymentModality,
    bool? groupByCashierOperator,
    bool? groupBySeller,
    int? topCount,
  }) {
    return GetSaleStatisticsParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      enterpriseIds: enterpriseIds ?? this.enterpriseIds,
      groupByEnterprise: groupByEnterprise ?? this.groupByEnterprise,
      groupByYear: groupByYear ?? this.groupByYear,
      groupByMonth: groupByMonth ?? this.groupByMonth,
      groupByDay: groupByDay ?? this.groupByDay,
      groupByHour: groupByHour ?? this.groupByHour,
      groupByProduct: groupByProduct ?? this.groupByProduct,
      groupByProductDepartment:
          groupByProductDepartment ?? this.groupByProductDepartment,
      groupByProductSection:
          groupByProductSection ?? this.groupByProductSection,
      groupByPaymentFinalization:
          groupByPaymentFinalization ?? this.groupByPaymentFinalization,
      groupByPaymentModality:
          groupByPaymentModality ?? this.groupByPaymentModality,
      groupByCashierOperator:
          groupByCashierOperator ?? this.groupByCashierOperator,
      groupBySeller: groupBySeller ?? this.groupBySeller,
      topCount: topCount ?? this.topCount,
    );
  }
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
