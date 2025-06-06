import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPaymentTypePresenter extends GetxController
    with
        SaleMovementManager,
        UIErrorManager,
        LoadingManager,
        LastGetSalesParamsManager,
        PeriodTypeManager
    implements PaymentTypePresenter {
  final LoadSaleMovements loadSaleMovements;

  GetxPaymentTypePresenter({
    required this.loadSaleMovements,
  });

  @override
  Future<void> getSales(
    HomePresenter homePresenter, {
    PeriodType? periodType,
    bool? forceRefresh,
  }) async {
    if (isLoadingValue == true) {
      return;
    }
    try {
      isLoading = true;
      mainError = null;

      if (periodType != null) {
        selectedPeriod = periodType;
      }

      final canSearchAgain = SalesHelper.canSearch(
        forceRefresh: forceRefresh,
        lastGetSalesParams: lastGetSalesParams,
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

      final salesByModality = await loadSaleMovements.get(
        GetSalesParams(
          startDate: startDate,
          endDate:
              selectedPeriodValue == PeriodType.daily ? startDate : endDate,
          groupByEnterprise: true,
          groupByDay: true,
          groupByPaymentModality: true,
        ),
      );

      saleMovements = salesByModality
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      final getSalesParams = GetSalesParams(
        startDate: startDate,
        endDate: selectedPeriodValue == PeriodType.daily ? startDate : endDate,
        groupByEnterprise: true,
        groupByDay: true,
        groupByPaymentFinalization: true,
      );

      final salesByFinalization = await loadSaleMovements.get(getSalesParams);

      salesByFinaliztions = salesByFinalization
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();

      lastParams = getSalesParams;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void emitLoadingAgain() {
    if (isLoadingValue == true) {
      isLoading = false;
      isLoading = true;
    }
  }

  final _saleMovementsFinalizations = Rx<List<SaleMovementViewModel>?>(null);
  @override
  List<SaleMovementViewModel>? get saleMovementsByFinalizations =>
      _saleMovementsFinalizations.value;
  set salesByFinaliztions(List<SaleMovementViewModel>? value) =>
      _saleMovementsFinalizations.value = value;
}
