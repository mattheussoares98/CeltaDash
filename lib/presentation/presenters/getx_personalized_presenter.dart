import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxPersonalizedPresenter extends GetxController
    with ErrorHandling, SaleStatisticsManager, UIErrorManager, LoadingManager
    implements PersonalizedPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxPersonalizedPresenter({
    required this.loadSaleStatistics,
  });

  final appAnalyticsService = Get.find<AppAnalyticsService>();

  @override
  Future<void> getSales({
    required DateTime startDate,
    required DateTime endDate,
    required List<int>? enterpriseIds,
    required bool? groupByEnterprise,
    required bool? groupByYear,
    required bool? groupByMonth,
    required bool? groupByDay,
    required bool? groupByHour,
    required bool? groupByProduct,
    required bool? groupByProductDepartment,
    required bool? groupByProductSection,
    required bool? groupByPaymentFinalization,
    required bool? groupByPaymentModality,
    required bool? groupByCashierOperator,
    required bool? groupBySeller,
    required int? topCount,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final sales = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: startDate,
          endDate: endDate,
          enterpriseIds: enterpriseIds,
          groupByEnterprise: groupByEnterprise,
          groupByYear: groupByYear,
          groupByMonth: groupByMonth,
          groupByDay: groupByDay,
          groupByHour: groupByHour,
          groupByProduct: groupByProduct,
          groupByProductDepartment: groupByProductDepartment,
          groupByProductSection: groupByProductSection,
          groupByPaymentFinalization: groupByPaymentFinalization,
          groupByPaymentModality: groupByPaymentModality,
          groupByCashierOperator: groupByCashierOperator,
          groupBySeller: groupBySeller,
          topCount: topCount,
        ),
      );

      saleStatistics = sales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void changeSelectedDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
  }

  DateTime? _endDate;
  @override
  DateTime? get endDate => _endDate;

  DateTime? _startDate;
  @override
  DateTime? get startDate => _startDate;
}
