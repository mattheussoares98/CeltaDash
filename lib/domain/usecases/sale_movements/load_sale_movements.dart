import '../../entities/entities.dart';

abstract class LoadSaleMovements {
  Future<List<SaleMovementEntity>> get({
    required DateTime startDate,
    required DateTime endDate,
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
  });
}
