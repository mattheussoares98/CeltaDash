import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxDepartmentsPresenter extends GetxController
    with ErrorHandling,
        SaleStatisticsManager,
        UIErrorManager,
        LoadingManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements DepartmentsPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxDepartmentsPresenter({
    required this.loadSaleStatistics,
  });

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
      return;
    }
    try {
      isLoading = true;
      mainError = null;

      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = SearchHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: selectedPeriod == PeriodType.daily
            ? lastGetDailyParams
            : lastGetMonthlyParams,
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriod,
      );

      bool changedEnterprise = SearchHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriod,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastDailyParams: lastGetDailyParams,
        lastMonthlyParams: lastGetMonthlyParams,
      );

      if (!canSearchAgain && !changedEnterprise) {
        return;
      }

      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        selectedPeriod == PeriodType.daily ? homePresenter.selectedDate.day : 1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        1,
      ).subtract(Duration(days: 1));

      final params = GetSaleStatisticsParams(
        startDate: startDate,
        endDate: selectedPeriod == PeriodType.daily ? startDate : endDate,
        groupByEnterprise: true,
        groupByDay: selectedPeriod == PeriodType.daily,
        groupByMonth: selectedPeriod == PeriodType.monthly,
        groupByYear: selectedPeriod == PeriodType.monthly,
        groupByProductDepartment: true,
        groupByProductSection: true,
        enterpriseIds: homePresenter.selectedEnterprise == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
      );

      final response = await loadSaleStatistics.get(params);
      final newSales = (response as List)
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();
      if (selectedPeriod == PeriodType.daily) {
        lastGetDailyParams = params;
        dailyStatistics = newSales;
      } else {
        lastGetMonthlyParams = params;
        monthlyStatistics = newSales;
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
