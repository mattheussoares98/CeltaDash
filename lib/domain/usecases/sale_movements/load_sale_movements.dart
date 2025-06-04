import 'package:equatable/equatable.dart';

import '../../entities/entities.dart';

abstract class LoadSaleMovements {
  Future<List<SaleMovementEntity>> get(GetSalesParams parameters);
}

class GetSalesParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
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

  const GetSalesParams({
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
}
