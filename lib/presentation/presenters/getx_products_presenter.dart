import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxProductsPresenter extends GetxController
    with ErrorHandling,
        LoadingManager,
        UIErrorManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements ProductsPresenter {
  final LoadSaleStatistics loadSaleStatistics;
  final LocalStorage localStorage;

  GetxProductsPresenter({
    required this.loadSaleStatistics,
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
        0,
      );

      final params = GetSaleStatisticsParams(
        startDate: startDate,
        endDate: selectedPeriod == PeriodType.daily ? startDate : endDate,
        groupByDay:
            true /* selectedPeriod == PeriodType.daily ? true : false */, //TODO test this
        groupByProduct: true,
        groupByEnterprise: true,
        topCount: 200,
        enterpriseIds: homePresenter.selectedEnterprise == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
      );

      final response = await loadSaleStatistics.get(params);
      lastParams = params;

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

  final _dailyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get dailyStatistics => _dailyStatistics.value;
  set dailyStatistics(List<SaleStatisticViewModel>? value) =>
      _dailyStatistics.value = value;

  final _monthlyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get monthlyStatistics =>
      _monthlyStatistics.value;
  set monthlyStatistics(List<SaleStatisticViewModel>? value) =>
      _monthlyStatistics.value = value;
}
