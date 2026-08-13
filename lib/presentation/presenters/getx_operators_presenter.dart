import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../ui/services/services.dart';
import '../mixins/mixins.dart';

class GetxOperatorsPresenter extends GetxController
    with
        ErrorHandling,
        LoadingManager,
        UIErrorManager,
        SaleStatisticsManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements OperatorsPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxOperatorsPresenter({required this.loadSaleStatistics});

  final appAnalyticsService = Get.find<AppAnalyticsService>();
  final homePresenter = Get.find<HomePresenter>();

  @override
  Future<void> getSales({
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
      return;
    }

    isLoading = true;
    mainError = null;

    try {
      if (periodType != null) {
        selectedPeriod = periodType;
      }

      GetSaleStatisticsParams? lastGetSalesParams() {
        if (selectedPeriod == PeriodType.daily) {
          return lastGetDailyParams;
        } else if (selectedPeriod == PeriodType.monthly) {
          return lastGetMonthlyParams;
        } else if (selectedPeriod == PeriodType.yearly) {
          return lastGetYearlyParams;
        }
        return null;
      }

      final canSearchAgain = SearchHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: lastGetSalesParams(),
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriod,
      );

      final changedTheEnterprise = SearchHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriod,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastDailyParams: lastGetDailyParams,
        lastMonthlyParams: lastGetMonthlyParams,
        lastYearlyParams: lastGetYearlyParams,
      );

      if (!canSearchAgain && !changedTheEnterprise) {
        return;
      }

      late GetSaleStatisticsParams getSalesParams;

      if (selectedPeriod == PeriodType.daily) {
        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        getSalesParams = GetSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: startDate,
          endDate: startDate,
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByDay: true,
        );
      } else if (selectedPeriod == PeriodType.monthly) {
        getSalesParams = GetSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month,
          ),
          endDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month + 1,
            0,
          ),
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByMonth: true,
        );
      } else if (selectedPeriod == PeriodType.yearly) {
        getSalesParams = GetSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDate.year),
          endDate: DateTime(homePresenter.selectedDate.year, 12, 31),
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByYear: true,
        );
      }
      final remoteSales = await loadSaleStatistics.get(getSalesParams);

      final newSales = remoteSales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      if (selectedPeriod == PeriodType.daily) {
        dailyStatistics = newSales;
        lastGetDailyParams = getSalesParams;
      } else if (selectedPeriod == PeriodType.monthly) {
        monthlyStatistics = newSales;
        lastGetMonthlyParams = getSalesParams;
      } else if (selectedPeriod == PeriodType.yearly) {
        yearlyStatistics = newSales;
        lastGetYearlyParams = getSalesParams;
      }

      appAnalyticsService.addNewMonthlyAnalytic(
        reportType: ReportType.operators,
        periodType: selectedPeriod,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
