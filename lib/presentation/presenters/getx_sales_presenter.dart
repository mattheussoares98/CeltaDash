import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSalesPresenter extends GetxController
    with
        ErrorHandling,
        LoadingManager,
        UIErrorManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager,
        SaleStatisticsManager
    implements SalesPresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxSalesPresenter({required this.loadSaleStatistics});

  @override
  void onInit() {
    super.onInit();
    selectedPeriod = PeriodType.hourly;
  }

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

    isLoading = true;
    mainError = null;

    try {
      if (periodType != null) {
        selectedPeriod = periodType;
      }

      GetSaleStatisticsParams? lastGetSalesParams() {
        if (selectedPeriod == PeriodType.hourly) {
          return lastGetHourlyParams;
        } else if (selectedPeriod == PeriodType.daily) {
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
        lastHourlyParams: lastGetHourlyParams,
        lastDailyParams: lastGetDailyParams,
        lastMonthlyParams: lastGetMonthlyParams,
        lastYearlyParams: lastGetYearlyParams,
      );

      if (!canSearchAgain && !changedTheEnterprise) {
        return;
      }

      final startDate = DateTime(
        selectedPeriod == PeriodType.yearly
            ? homePresenter.selectedDate.year - 2
            : homePresenter.selectedDate.year,
        selectedPeriod == PeriodType.daily ||
                selectedPeriod == PeriodType.hourly
            ? homePresenter.selectedDate.month
            : 1,
        selectedPeriod == PeriodType.hourly
            ? homePresenter.selectedDate.day
            : 1,
      );
      final endDate = DateTime(
        homePresenter.selectedDate.year,
        selectedPeriod == PeriodType.daily
            ? homePresenter.selectedDate.month + 1
            : 12,
        selectedPeriod == PeriodType.hourly
            ? homePresenter.selectedDate.day
            : (selectedPeriod == PeriodType.daily ? 0 : 31),
      );

      final getSalesParams = GetSaleStatisticsParams(
        enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: startDate,
        endDate: selectedPeriod == PeriodType.hourly ? startDate : endDate,
        groupByEnterprise: true,
        groupByHour: selectedPeriod == PeriodType.hourly,
        groupByDay: selectedPeriod == PeriodType.daily,
        groupByMonth: selectedPeriod == PeriodType.monthly,
        groupByYear: selectedPeriod == PeriodType.yearly,
      );

      final remoteSales = await loadSaleStatistics.get(getSalesParams);
      final newSales = remoteSales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      if (selectedPeriod == PeriodType.hourly) {
        hourlyStatistics = newSales;
        lastGetHourlyParams = getSalesParams;
      } else if (selectedPeriod == PeriodType.daily) {
        dailyStatistics = newSales;
        lastGetDailyParams = getSalesParams;
      } else if (selectedPeriod == PeriodType.monthly) {
        monthlyStatistics = newSales;
        lastGetMonthlyParams = getSalesParams;
      } else if (selectedPeriod == PeriodType.yearly) {
        yearlyStatistics = newSales;
        lastGetYearlyParams = getSalesParams;
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
