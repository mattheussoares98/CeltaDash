import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSellersPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        SaleStatisticsManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements SellersPresenter {
  final EcLoadSaleStatistics ecLoadSaleStatistics;

  GetxSellersPresenter({required this.ecLoadSaleStatistics});

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
        if (selectedPeriod == PeriodType.daily) {
          return lastGetDailyParams;
        } else if (selectedPeriod == PeriodType.monthly) {
          return lastGetMonthlyParams;
        } else if (selectedPeriod == PeriodType.yearly) {
          return lastGetYearlyParams;
        }
        return null;
      }

      final canSearchAgain = StatisticsHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: lastGetSalesParams(),
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriod,
      );

      final changedTheEnterprise = StatisticsHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriod,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastDailyParams: lastGetDailyParams,
        lastMonthlyParams: lastGetMonthlyParams,
        lastYearlyParams: lastGetYearlyParams,
      );

      if (!canSearchAgain && !changedTheEnterprise) {
        return;
      }

      late GetEcSaleStatisticsParams getSalesParams;

      if (selectedPeriod == PeriodType.daily) {
        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        getSalesParams = GetEcSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: startDate,
          endDate: startDate,
          groupByEnterprise: true,
          groupBySeller: true,
          groupByDay: true,
        );
      } else if (selectedPeriod == PeriodType.monthly) {
        getSalesParams = GetEcSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month,
            1,
          ),
          endDate: DateTime(
            homePresenter.selectedDate.year,
            homePresenter.selectedDate.month + 1,
            0,
          ),
          groupByEnterprise: true,
          groupBySeller: true,
          groupByMonth: true,
        );
      } else if (selectedPeriod == PeriodType.yearly) {
        getSalesParams = GetEcSaleStatisticsParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDate.year),
          endDate: DateTime(homePresenter.selectedDate.year, 12, 31),
          groupByEnterprise: true,
          groupBySeller: true,
          groupByYear: true,
        );
      }
      final remoteSales = await ecLoadSaleStatistics.get(getSalesParams);

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
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
