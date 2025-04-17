abstract class LoadSaleMovements {
  Future<void> get({
    List<int>? enterpriseIds,
    DateTime? startDate,
    DateTime? endDate,
    bool? groupByEnterprise,
    bool? groupByYear,
    bool? groupByMonth,
    bool? groupByDay,
    bool? groupByHour,
    bool? groupByProduct,
  });
}
