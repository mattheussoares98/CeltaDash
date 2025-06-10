import 'package:equatable/equatable.dart';

import '../../entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class EcLoadSaleStatistics {
  Future<List<SaleStatisticsEntity>> get(GetEcSaleStatisticsParams params);
}

class GetEcSaleStatisticsParams extends Equatable implements DateRangeParams {
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

  const GetEcSaleStatisticsParams({
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
