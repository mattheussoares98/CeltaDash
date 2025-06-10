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
  final EcLoadSaleStatistics ecLoadSaleStatistics;

  GetxPaymentTypePresenter({
    required this.ecLoadSaleStatistics,
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
        periodType: selectedPeriod,
      );

      if (!canSearchAgain) {
        return;
      }

      final startDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month,
        selectedPeriod == PeriodType.daily
            ? homePresenter.selectedDate.day
            : 1,
      );

      final endDate = DateTime(
        homePresenter.selectedDate.year,
        homePresenter.selectedDate.month + 1,
        1,
      ).subtract(Duration(days: 1));

      final salesByModality = await ecLoadSaleStatistics.get(
        GetEcSaleStatisticsParams(
          startDate: startDate,
          endDate:
              selectedPeriod == PeriodType.daily ? startDate : endDate,
          groupByEnterprise: true,
          groupByDay: true,
          groupByPaymentModality: true,
        ),
      );

      saleStatistics = salesByModality
          .map((e) => SaleStatisticsModel.fromEntity(e).toViewModel())
          .toList();

      final getSalesParams = GetEcSaleStatisticsParams(
        startDate: startDate,
        endDate: selectedPeriod == PeriodType.daily ? startDate : endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByPaymentFinalization: true,
      );

      final salesByFinalization = await ecLoadSaleStatistics.get(getSalesParams);

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
