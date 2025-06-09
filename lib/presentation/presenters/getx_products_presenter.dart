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
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements ProductsPresenter {
  final EcLoadSaleStatistics ecLoadSaleStatistics;
  final LocalStorage localStorage;

  GetxProductsPresenter({
    required this.ecLoadSaleStatistics,
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

      final canSearchAgain = StatisticsHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: selectedPeriodValue == PeriodType.daily
            ? lastGetDailyParams
            : lastGetMonthlyParams,
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriodValue,
      );

      bool changedEnterprise = StatisticsHelper.changedTheEnterprise(
        selectedPeriodType: selectedPeriodValue,
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
        selectedPeriodValue == PeriodType.daily
            ? homePresenter.selectedDate.day
            : 1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        0,
      );

      final params = GetEcSaleStatisticsParams(
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

      final response = await ecLoadSaleStatistics.get(params);
      lastParams = params;

      final newSales = (response as List)
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();
      if (selectedPeriodValue == PeriodType.daily) {
        lastGetDailyParams = params;
        dailyStatistics = newSales;
      } else {
        lastGetMonthlyParams = params;
        monthlyStatistics = newSales;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _dailyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get dailyStatistics =>
      _dailyStatistics.value;
  set dailyStatistics(List<SaleStatisticViewModel>? value) =>
      _dailyStatistics.value = value;

  final _monthlyStatistics = Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get monthlyStatistics =>
      _monthlyStatistics.value;
  set monthlyStatistics(List<SaleStatisticViewModel>? value) =>
      _monthlyStatistics.value = value;
}
