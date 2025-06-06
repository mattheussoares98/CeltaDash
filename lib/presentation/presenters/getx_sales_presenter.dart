import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSalesPresenter extends GetxController
    with LoadingManager, UIErrorManager
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
        _selectedPeriodType = periodType;
      }

      GetSalesParams? lastGetSalesParams() {
        if (_selectedPeriodType == PeriodType.daily) {
          return _lastGetDailyParams;
        } else if (_selectedPeriodType == PeriodType.monthly) {
          return _lastGetMonthlyParams;
        } else if (_selectedPeriodType == PeriodType.yearly) {
          return _lastGetYearlyParams;
        }
        return null;
      }

      final canSearchAgain = SalesHelper.canSearch(
        forceRefresh: forceRefresh,
        lastGetSalesParams: lastGetSalesParams(),
        selectedDate: homePresenter.selectedDate,
        periodType: _selectedPeriodType,
      );

      bool changedTheEnterprise() {
        if (_selectedPeriodType == PeriodType.daily) {
          return _lastGetDailyParams?.enterpriseIds?.isNotEmpty == true &&
              _lastDailyEnterprise?.id?.toInt() !=
                  homePresenter.selectedEnterprise?.id?.toInt();
        } else if (_selectedPeriodType == PeriodType.monthly) {
          return _lastGetMonthlyParams?.enterpriseIds?.isNotEmpty == true &&
              _lastMonthlyEnterprise?.id?.toInt() !=
                  homePresenter.selectedEnterprise?.id?.toInt();
        } else if (_selectedPeriodType == PeriodType.yearly) {
          return _lastGetYearlyParams?.enterpriseIds?.isNotEmpty == true &&
              _lastYearlyEnterprise?.id?.toInt() !=
                  homePresenter.selectedEnterprise?.id?.toInt();
        }
        return false;
      }

      if (!canSearchAgain && !changedTheEnterprise()) {
        return;
      }

      late GetSalesParams getSalesParams;

      if (_selectedPeriodType == PeriodType.daily) {
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
      } else if (_selectedPeriodType == PeriodType.monthly) {
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
      } else if (_selectedPeriodType == PeriodType.yearly) {
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

      if (_selectedPeriodType == PeriodType.daily) {
        salesByDay = newSales;
        _lastGetDailyParams = getSalesParams;
        _lastDailyEnterprise = homePresenter.selectedEnterprise;
      } else if (_selectedPeriodType == PeriodType.monthly) {
        salesByMonth = newSales;
        _lastGetMonthlyParams = getSalesParams;
        _lastMonthlyEnterprise = homePresenter.selectedEnterprise;
      } else if (_selectedPeriodType == PeriodType.yearly) {
        salesByYear = newSales;
        _lastGetYearlyParams = getSalesParams;
        _lastYearlyEnterprise = homePresenter.selectedEnterprise;
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

  EnterpriseViewModel? _lastDailyEnterprise;
  @override
  EnterpriseViewModel? get lastDailyEnterprise => _lastDailyEnterprise;
  EnterpriseViewModel? _lastMonthlyEnterprise;
  @override
  EnterpriseViewModel? get lastMonthlyEnterprise => _lastMonthlyEnterprise;
  EnterpriseViewModel? _lastYearlyEnterprise;
  @override
  EnterpriseViewModel? get lastYearlyEnterprise => _lastYearlyEnterprise;

  PeriodType _selectedPeriodType = PeriodType.daily;
  //TODO create mixin
  @override
  PeriodType get selectedPeriodType => _selectedPeriodType;

  GetSalesParams? _lastGetDailyParams;
  GetSalesParams? _lastGetMonthlyParams;
  GetSalesParams? _lastGetYearlyParams;
  @override
  GetSalesParams? get lastGetDailyParams => _lastGetDailyParams;
  @override
  GetSalesParams? get lastGetMonthlyParams => _lastGetMonthlyParams;
  @override
  GetSalesParams? get lastGetYearlyParams => _lastGetYearlyParams;
}
