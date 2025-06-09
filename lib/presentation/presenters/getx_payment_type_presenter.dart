import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPaymentTypePresenter extends GetxController
    with
        SaleStatisticsManager,
        UIErrorManager,
        LoadingManager,
        LastGetSalesStatisticsParamsManager,
        PeriodTypeManager
    implements PaymentTypePresenter {
  final LoadSaleStatistics loadSaleStatistics;

  GetxPaymentTypePresenter({
    required this.loadSaleStatistics,
  });

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

    try {
      isLoading = true;
      mainError = null;

      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = StatisticsHelper.canSearch(
        forceRefresh: forceRefresh,
        lastParams: lastGetStatisticsParams,
        selectedDate: homePresenter.selectedDate,
        periodType: selectedPeriodValue,
      );

      if (!canSearchAgain) {
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
        1,
      ).subtract(Duration(days: 1));

      final salesByModality = await loadSaleStatistics.get(
        GetSaleStatisticsParams(
          startDate: startDate,
          endDate:
              selectedPeriodValue == PeriodType.daily ? startDate : endDate,
          groupByEnterprise: true,
          groupByDay: true,
          groupByPaymentModality: true,
        ),
      );

      saleStatistics = salesByModality
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      final getSalesParams = GetSaleStatisticsParams(
        startDate: startDate,
        endDate: selectedPeriodValue == PeriodType.daily ? startDate : endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByPaymentFinalization: true,
      );

      final salesByFinalization = await loadSaleStatistics.get(getSalesParams);

      salesByFinaliztions = salesByFinalization
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      lastParams = getSalesParams;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _saleStatisticsByFinalizations =
      Rx<List<SaleStatisticViewModel>?>(null);
  @override
  List<SaleStatisticViewModel>? get saleStatisticsByFinalizations =>
      _saleStatisticsByFinalizations.value;
  set salesByFinaliztions(List<SaleStatisticViewModel>? value) =>
      _saleStatisticsByFinalizations.value = value;
}
