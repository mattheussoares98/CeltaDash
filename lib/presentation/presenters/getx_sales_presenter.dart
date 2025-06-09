import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSalesPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager,
        SaleStatisticsManager
    implements SalesPresenter {
  final EcLoadSaleStatistics ecLoadSaleStatistics;

  GetxSalesPresenter({required this.ecLoadSaleStatistics});

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

      GetEcSaleStatisticsParams? lastGetSalesParams() {
        if (selectedPeriodValue == PeriodType.daily) {
          return lastGetDailyParams;
        } else if (selectedPeriodValue == PeriodType.monthly) {
          return lastGetMonthlyParams;
        } else if (selectedPeriodValue == PeriodType.yearly) {
          return lastGetYearlyParams;
        }
        return null;
      }

      final canSearchAgain = StatisticsHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: lastGetSalesParams(),
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriodValue,
      );

      final changedTheEnterprise = StatisticsHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriodValue,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastDailyParams: lastGetDailyParams,
        lastMonthlyParams: lastGetMonthlyParams,
        lastYearlyParams: lastGetYearlyParams,
      );

      if (!canSearchAgain && !changedTheEnterprise) {
        return;
      }

      late GetEcSaleStatisticsParams getSalesParams;

      if (selectedPeriodValue == PeriodType.daily) {
        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
        ).subtract(Duration(days: 1));

        getSalesParams = GetEcSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByHour: true,
        );
      } else if (selectedPeriodValue == PeriodType.monthly) {
        getSalesParams = GetEcSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDate.year, 1, 1),
          endDate: DateTime(
            homePresenter.selectedDate.year,
            12,
            31,
          ),
          groupByEnterprise: true,
          groupByMonth: true,
        );
      } else if (selectedPeriodValue == PeriodType.yearly) {
        getSalesParams = GetEcSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDate.year - 2),
          endDate: DateTime(
            homePresenter.selectedDate.year,
            12,
            31,
          ),
          groupByEnterprise: true,
          groupByYear: true,
        );
      }
      final remoteSales = await ecLoadSaleStatistics.get(getSalesParams);

      final newSales = remoteSales
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      if (selectedPeriodValue == PeriodType.daily) {
        dailyStatistics = newSales;
        lastGetDailyParams = getSalesParams;
      } else if (selectedPeriodValue == PeriodType.monthly) {
        monthlyStatistics = newSales;
        lastGetMonthlyParams = getSalesParams;
      } else if (selectedPeriodValue == PeriodType.yearly) {
        yearlyStatistics = newSales;
        lastGetYearlyParams = getSalesParams;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
