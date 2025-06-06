import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxProductsPresenter extends GetxController
    with
        LoadingManager,
        UIErrorManager,
        LastGetSalesParamsManager,
        PeriodTypeManager
    implements ProductsPresenter {
  final LoadSaleMovements loadSaleMovements;
  final LocalStorage localStorage;

  GetxProductsPresenter({
    required this.loadSaleMovements,
    required this.localStorage,
  });

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = SalesHelper.canSearch(
        forceRefresh: forceRefresh,
        lastGetSalesParams: selectedPeriodValue == PeriodType.daily
            ? lastGetDailyParams
            : lastGetMonthlyParams,
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriodValue,
      );

      bool changedEnterprise = SalesHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriodValue,
        selectedEnterprise: homePresenter.selectedEnterprise,
        lastGetDailyParams: lastGetDailyParams,
        lastGetMonthlyParams: lastGetMonthlyParams,
      );

      if (!canSearchAgain && !changedEnterprise) {
        return;
      }

      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        selectedPeriodValue == PeriodType.daily
            ? homePresenter.selectedDate.day
            : 1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        0,
      );

      final params = GetSalesParams(
        startDate: startDate,
        endDate: selectedPeriodValue == PeriodType.daily ? startDate : endDate,
        groupByDay: true,
        groupByProduct: true,
        groupByEnterprise: true,
        topCount: 200,
        enterpriseIds: homePresenter.selectedEnterprise == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
      );

      final response = await loadSaleMovements.get(params);
      lastParams = params;

      final newSales = (response as List)
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
      if (selectedPeriodValue == PeriodType.daily) {
        lastDaily = params;
        dailySaleMovements = newSales;
      } else {
        lastMonthly = params;
        monthlySaleMovements = newSales;
      }

      _lastEnterpriseLoadedData = homePresenter.selectedEnterprise;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  EnterpriseViewModel? _lastEnterpriseLoadedData;
  @override
  EnterpriseViewModel? get lastEnterpriseLoadedData =>
      _lastEnterpriseLoadedData; //TODO remove this

  final _dailySaleMovements = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get dailySaleMovements =>
      _dailySaleMovements.value;
  set dailySaleMovements(List<SaleMovementViewModel>? value) =>
      _dailySaleMovements.value = value;

  final _monthlySaleMovements = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get monthlySaleMovements =>
      _monthlySaleMovements.value;
  set monthlySaleMovements(List<SaleMovementViewModel>? value) =>
      _monthlySaleMovements.value = value;
}
