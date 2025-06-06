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
        LastGetSalesParamsManager,
        PeriodTypeManager
    implements SalesPresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxSalesPresenter({required this.loadSaleMovements});

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
          1,
        );
        final endDate = DateTime(
          homePresenter.selectedDate.year,
          homePresenter.selectedDate.month + 1,
        ).subtract(Duration(days: 1));

        getSalesParams = GetSalesParams(
          enterpriseIds: [homePresenter.selectedEnterprise!.id!.toInt()],
          startDate: startDate,
          endDate: endDate,
          groupByEnterprise: true,
          groupByHour: true,
        );
      } else if (selectedPeriodValue == PeriodType.monthly) {
        getSalesParams = GetSalesParams(
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
        getSalesParams = GetSalesParams(
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
      final remoteSales = await loadSaleMovements.get(getSalesParams);

      final newSales = remoteSales
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      if (selectedPeriodValue == PeriodType.daily) {
        salesByDay = newSales;
        lastDaily = getSalesParams;
      } else if (selectedPeriodValue == PeriodType.monthly) {
        salesByMonth = newSales;
        lastMonthly = getSalesParams;
      } else if (selectedPeriodValue == PeriodType.yearly) {
        salesByYear = newSales;
        lastYearly = getSalesParams;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _saleMovementsByYear = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByYear =>
      _saleMovementsByYear.value;
  set salesByYear(List<SaleMovementViewModel>? value) =>
      _saleMovementsByYear.value = value;

  final _saleMovementsByMonth = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByMonth =>
      _saleMovementsByMonth.value;
  set salesByMonth(List<SaleMovementViewModel>? value) =>
      _saleMovementsByMonth.value = value;

  final _saleMovementsByDay = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByDay =>
      _saleMovementsByDay.value;
  set salesByDay(List<SaleMovementViewModel>? value) =>
      _saleMovementsByDay.value = value;
}
