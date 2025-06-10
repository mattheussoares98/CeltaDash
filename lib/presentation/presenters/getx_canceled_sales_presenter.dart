import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCanceledSalesPresenter extends GetxController
    with
        UIErrorManager,
        LoadingManager,
        EcSaleMovementManager,
        PeriodTypeManager,
        LastGetSaleMovementParamsManager
    implements CanceledSalesPresenter {
  final EcLoadSaleMovements ecLoadSaleMovements;

  GetxCanceledSalesPresenter({
    required this.ecLoadSaleMovements,
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

      final params = GetEcSaleMovementParams(
        enterpriseIds: homePresenter.selectedEnterprise?.id == null
            ? []
            : [homePresenter.selectedEnterprise!.id!.toInt()],
        startDate: startDate,
        endDate: selectedPeriod == PeriodType.daily ? startDate : endDate,
        onlyCancelled: true,
      );
      final response = await ecLoadSaleMovements.get(params);
      lastParams = params;

      final newSales = (response as List)
          .map((e) => SaleMovementModel.fromEntity(e).toViewModel())
          .toList();
      if (selectedPeriod == PeriodType.daily) {
        lastGetDailyParams = params;
        dailySales = newSales;
      } else {
        lastGetMonthlyParams = params;
        monthlySales = newSales;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
