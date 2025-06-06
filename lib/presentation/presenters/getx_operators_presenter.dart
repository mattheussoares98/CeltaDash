import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxOperatorsPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        SaleMovementManager,
        LastGetSalesParamsManager,
        PeriodTypeManager
    implements OperatorsPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxOperatorsPresenter({required this.loadSaleMovements});

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

      GetSalesParams? lastGetSalesParams() {
        if (selectedPeriodValue == PeriodType.daily) {
          return lastGetDailyParams;
        } else if (selectedPeriodValue == PeriodType.monthly) {
          return lastGetMonthlyParams;
        } else if (selectedPeriodValue == PeriodType.yearly) {
          return lastGetYearlyParams;
        }
        return null;
      }

      final canSearchAgain = SalesHelper.canSearch(
        forceRefresh: forceRefresh,
        lastGetSalesParams: lastGetSalesParams(),
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriodValue,
      );

      final changedTheEnterprise = SalesHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriodValue,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastGetDailyParams: lastGetDailyParams,
        lastGetMonthlyParams: lastGetMonthlyParams,
        lastGetYearlyParams: lastGetYearlyParams,
      );

      if (!canSearchAgain && !changedTheEnterprise) {
        return;
      }

      late GetSalesParams getSalesParams;

      if (selectedPeriodValue == PeriodType.daily) {
        final startDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month,
          homePresenter.selectedDate.day,
        );

        getSalesParams = GetSalesParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: startDate,
          endDate: startDate,
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByDay: true,
        );
      } else if (selectedPeriodValue == PeriodType.monthly) {
        getSalesParams = GetSalesParams(
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
          groupByCashierOperator: true,
          groupByMonth: true,
        );
      } else if (selectedPeriodValue == PeriodType.yearly) {
        getSalesParams = GetSalesParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: DateTime(homePresenter.selectedDate.year),
          endDate: DateTime(homePresenter.selectedDate.year, 12, 31),
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByYear: true,
        );
      }
      final remoteSales = await loadSaleMovements.get(getSalesParams);

      final newSales = remoteSales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      if (selectedPeriodValue == PeriodType.daily) {
        dailySales = newSales;
        lastGetDailyParams = getSalesParams;
      } else if (selectedPeriodValue == PeriodType.monthly) {
        monthlySales = newSales;
        lastGetMonthlyParams = getSalesParams;
      } else if (selectedPeriodValue == PeriodType.yearly) {
        yearlySales = newSales;
        lastGetYearlyParams = getSalesParams;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
